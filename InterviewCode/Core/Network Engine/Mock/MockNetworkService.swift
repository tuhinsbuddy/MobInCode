import Foundation

/// Test double for `NetworkService`. Inject into ViewModels or use cases during unit tests.
///
/// Usage:
/// ```swift
/// let mock = MockNetworkService()
/// mock.stubbedResult = User(id: "1", name: "Tuhin")
/// mock.stubbedError = nil
///
/// let sut = UserViewModel(networkService: mock)
/// await sut.loadProfile()
///
/// XCTAssertEqual(mock.requestCallCount, 1)
/// XCTAssertEqual(sut.user?.name, "Tuhin")
/// ```
public final class MockNetworkService: NetworkService {

    // MARK: - Stubbing

    /// Set this to provide a typed stub for any request.
    public var stubbedResult: Any?

    /// Set this to simulate a network error.
    public var stubbedError: NetworkError?

    /// Simulate a configurable response delay (seconds).
    public var simulatedDelay: TimeInterval = 0

    // MARK: - Inspection

    public private(set) var requestCallCount = 0
    public private(set) var lastEndpoint: APIEndpoint?
    public private(set) var uploadCallCount = 0

    public init() {}

    // MARK: - NetworkService

    public func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        decoder: JSONDecoder
    ) async throws -> NetworkResponse<T> {
        requestCallCount += 1
        lastEndpoint = endpoint

        if simulatedDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))
        }

        if let error = stubbedError { throw error }

        guard let value = stubbedResult as? T else {
            throw NetworkError.decodingFailed(
                NSError(domain: "MockNetworkService", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Stub type mismatch for \(T.self)"])
            )
        }

        let httpResponse = HTTPURLResponse(
            url: endpoint.url ?? URL(string: "https://mock.test")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return NetworkResponse(value: value, httpResponse: httpResponse, rawData: Data())
    }

    public func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        retryPolicy: RetryPolicy,
        decoder: JSONDecoder
    ) async throws -> NetworkResponse<T> {
        try await request(endpoint, decoder: decoder)
    }

    public func retryableRequest<T: Decodable>(
        _ endpoint: APIEndpoint,
        decoder: JSONDecoder
    ) -> RetryableRequest<T> {
        RetryableRequest { try await self.request(endpoint, decoder: decoder) }
    }

    public func upload(
        _ endpoint: APIEndpoint,
        multipartData: MultipartFormData
    ) async throws -> NetworkResponse<Data> {
        uploadCallCount += 1
        if let error = stubbedError { throw error }
        let httpResponse = HTTPURLResponse(
            url: endpoint.url ?? URL(string: "https://mock.test")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return NetworkResponse(value: Data(), httpResponse: httpResponse, rawData: Data())
    }

    public func uploadWithProgress(
        _ endpoint: APIEndpoint,
        multipartData: MultipartFormData
    ) -> AsyncThrowingStream<UploadProgress, Error> {
        AsyncThrowingStream { continuation in
            if let error = self.stubbedError {
                continuation.finish(throwing: error)
                return
            }
            let httpResponse = HTTPURLResponse(
                url: endpoint.url ?? URL(string: "https://mock.test")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            // Simulate progress steps
            continuation.yield(.progress(0.5))
            continuation.yield(.progress(1.0))
            continuation.yield(.completed(NetworkResponse(value: Data(), httpResponse: httpResponse, rawData: Data())))
            continuation.finish()
        }
    }

    public func download(_ endpoint: APIEndpoint) async throws -> URL {
        if let error = stubbedError { throw error }
        return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("mock-download")
    }
}
