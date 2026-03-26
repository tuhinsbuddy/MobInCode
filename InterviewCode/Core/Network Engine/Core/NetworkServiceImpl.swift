import Foundation

/// Production URLSession-backed implementation of `NetworkService`.
///
/// Implemented as a Swift `actor` to guarantee thread-safe access to
/// shared mutable state (interceptors, session) without manual locking.
///
/// Responsibilities:
/// - Building URLRequests from `APIEndpoint`
/// - Running the interceptor chain (adapt → execute → retry)
/// - Auto-retry with configurable `RetryPolicy` (exponential backoff + jitter)
/// - Coordinating token refresh through `AuthInterceptor`
/// - Streaming upload progress via `AsyncThrowingStream`
/// - Task cancellation via `withTaskCancellationHandler`
public actor NetworkServiceImpl: NetworkService {

    // MARK: - Properties

    private let session: URLSession
    private let interceptors: [RequestInterceptor]
    private let defaultRetryPolicy: RetryPolicy
    private let loggingInterceptor: LoggingInterceptor

    // MARK: - Init

    public init(
        session: URLSession = .shared,
        interceptors: [RequestInterceptor] = [],
        defaultRetryPolicy: RetryPolicy = .default,
        logLevel: LogLevel = .debug
    ) {
        self.session = session
        self.interceptors = interceptors
        self.defaultRetryPolicy = defaultRetryPolicy
        self.loggingInterceptor = LoggingInterceptor(logLevel: logLevel)
    }

    // MARK: - NetworkService: Standard Request

    public func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> NetworkResponse<T> {
        try await request(endpoint, retryPolicy: defaultRetryPolicy, decoder: decoder)
    }

    public func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        retryPolicy: RetryPolicy,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> NetworkResponse<T> {
        var urlRequest = try NetworkRequest.build(from: endpoint)

        // Run adapt phase on all interceptors
        if endpoint.requiresAuth {
            for interceptor in interceptors {
                urlRequest = try await interceptor.adapt(urlRequest)
            }
        }

        return try await executeWithRetry(
            request: urlRequest,
            endpoint: endpoint,
            retryPolicy: retryPolicy,
            attemptCount: 0,
            decoder: decoder
        )
    }

    // MARK: - NetworkService: Manual Retry

    public nonisolated func retryableRequest<T: Decodable>(
        _ endpoint: APIEndpoint,
        decoder: JSONDecoder = JSONDecoder()
    ) -> RetryableRequest<T> {
        RetryableRequest {
            try await self.request(endpoint, retryPolicy: .none, decoder: decoder)
        }
    }

    // MARK: - NetworkService: Upload

    public func upload(
        _ endpoint: APIEndpoint,
        multipartData: MultipartFormData
    ) async throws -> NetworkResponse<Data> {
        var urlRequest = try await NetworkRequest.build(from: endpoint)
        await urlRequest.setValue(
            ContentType.multipartFormData(boundary: multipartData.boundary).headerValue,
            forHTTPHeaderField: "Content-Type"
        )
        let body = await multipartData.build()
        let (data, response) = try await session.upload(for: urlRequest, from: body)
        return try processRawResponse(data: data, response: response)
    }

    /// Streams upload progress as a `Double` (0.0 – 1.0) then emits `.completed`.
    public nonisolated func uploadWithProgress(
        _ endpoint: APIEndpoint,
        multipartData: MultipartFormData
    ) -> AsyncThrowingStream<UploadProgress, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    var urlRequest = try await NetworkRequest.build(from: endpoint)
                    urlRequest.setValue(
                        ContentType.multipartFormData(boundary: multipartData.boundary).headerValue,
                        forHTTPHeaderField: "Content-Type"
                    )
                    let body = multipartData.build()

                    // Dedicated session with a progress-reporting delegate
                    let delegate = UploadProgressDelegate { progress in
                        continuation.yield(.progress(progress))
                    }
                    let progressSession = URLSession(
                        configuration: .default,
                        delegate: delegate,
                        delegateQueue: nil
                    )

                    let (data, response) = try await progressSession.upload(for: urlRequest, from: body)
                    let networkResponse: NetworkResponse<Data> = try processRawResponse(data: data, response: response)
                    continuation.yield(.completed(networkResponse))
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    // MARK: - NetworkService: Download

    public func download(_ endpoint: APIEndpoint) async throws -> URL {
        let urlRequest = try NetworkRequest.build(from: endpoint)
        let (tempURL, response) = try await session.download(for: urlRequest)
        guard
            let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NetworkError.serverError(statusCode: code, data: nil)
        }
        return tempURL
    }

    // MARK: - Auto-Retry Engine

    /// Recursively retries the request according to the retry policy.
    /// Interceptors (e.g. AuthInterceptor) get first priority to handle errors (token refresh).
    /// Structural errors (timeout, 5xx) are then retried with exponential backoff.
    private func executeWithRetry<T: Decodable>(
        request: URLRequest,
        endpoint: APIEndpoint,
        retryPolicy: RetryPolicy,
        attemptCount: Int,
        decoder: JSONDecoder
    ) async throws -> NetworkResponse<T> {
        do {
            return try await execute(request: request, decoder: decoder)
        } catch let error as NetworkError {

            // 1. Give interceptors a chance to handle the error (e.g. 401 → refresh token)
            for interceptor in interceptors {
                let shouldRetry = await interceptor.retry(request, dueTo: error, attemptCount: attemptCount)
                if shouldRetry, attemptCount < retryPolicy.maxRetries {
                    var refreshedRequest = request
                    for interceptor in interceptors {
                        refreshedRequest = try await interceptor.adapt(refreshedRequest)
                    }
                    return try await executeWithRetry(
                        request: refreshedRequest,
                        endpoint: endpoint,
                        retryPolicy: retryPolicy,
                        attemptCount: attemptCount + 1,
                        decoder: decoder
                    )
                }
            }

            // 2. Auto-retry retryable errors (timeout, 5xx, no connection)
            guard retryPolicy.shouldRetry(error: error), attemptCount < retryPolicy.maxRetries else {
                throw attemptCount >= retryPolicy.maxRetries && retryPolicy.maxRetries > 0
                    ? NetworkError.maxRetriesExceeded
                    : error
            }

            let delay = retryPolicy.delay(for: attemptCount)
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))

            return try await executeWithRetry(
                request: request,
                endpoint: endpoint,
                retryPolicy: retryPolicy,
                attemptCount: attemptCount + 1,
                decoder: decoder
            )
        }
    }

    // MARK: - Core Execution

    private func execute<T: Decodable>(
        request: URLRequest,
        decoder: JSONDecoder
    ) async throws -> NetworkResponse<T> {
        let (data, response): (Data, URLResponse)

        do {
            (data, response) = try await withTaskCancellationHandler {
                try await session.data(for: request)
            } onCancel: {
                // URLSession tasks are implicitly cancelled when the Task is cancelled.
                // Additional cleanup (e.g. invalidating a specific task) can go here.
            }
        } catch let urlError as URLError {
            throw mapURLError(urlError)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(nil)
        }

        loggingInterceptor.logResponse(data: data, response: httpResponse, for: request)

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.map(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            let decoded = try decoder.decode(T.self, from: data)
            return NetworkResponse(value: decoded, httpResponse: httpResponse, rawData: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    // MARK: - Helpers

    private nonisolated func processRawResponse(data: Data, response: URLResponse) throws -> NetworkResponse<Data> {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(nil)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.map(statusCode: httpResponse.statusCode, data: data)
        }
        return NetworkResponse(value: data, httpResponse: httpResponse, rawData: data)
    }

    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:  return .noInternetConnection
        case .timedOut:                                        return .timeout
        case .cancelled:                                       return .cancelled
        default:                                               return .unknown(error)
        }
    }
}

// MARK: - Upload Progress Delegate

/// URLSessionTaskDelegate that reports byte-level upload progress.
private final class UploadProgressDelegate: NSObject, URLSessionTaskDelegate {
    private let onProgress: (Double) -> Void

    init(onProgress: @escaping (Double) -> Void) {
        self.onProgress = onProgress
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        guard totalBytesExpectedToSend > 0 else { return }
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        onProgress(min(progress, 1.0))
    }
}
