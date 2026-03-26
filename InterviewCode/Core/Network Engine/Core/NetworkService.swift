import Foundation

// MARK: - Upload Progress

/// Emitted by upload streams to report progress or completion.
public enum UploadProgress {
    case progress(Double)                       // 0.0 – 1.0
    case completed(NetworkResponse<Data>)
}

// MARK: - NetworkService Protocol

/// The primary interface for all network operations.
/// Program against this protocol — not the concrete implementation —
/// to keep call sites testable and decoupled from URLSession.
public protocol NetworkService: AnyObject {

    // MARK: Standard Requests

    /// Performs a request and decodes the response to `T`.
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        decoder: JSONDecoder
    ) async throws -> NetworkResponse<T>

    /// Same as above but with an explicit retry policy.
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        retryPolicy: RetryPolicy,
        decoder: JSONDecoder
    ) async throws -> NetworkResponse<T>

    // MARK: Manual Retry

    /// Returns a `RetryableRequest` that the caller can explicitly re-execute.
    func retryableRequest<T: Decodable>(
        _ endpoint: APIEndpoint,
        decoder: JSONDecoder
    ) -> RetryableRequest<T>

    // MARK: Upload

    /// Uploads multipart data and returns the raw response.
    func upload(
        _ endpoint: APIEndpoint,
        multipartData: MultipartFormData
    ) async throws -> NetworkResponse<Data>

    /// Uploads multipart data and streams live progress updates.
    func uploadWithProgress(
        _ endpoint: APIEndpoint,
        multipartData: MultipartFormData
    ) -> AsyncThrowingStream<UploadProgress, Error>

    // MARK: Download

    /// Downloads a file and returns the temporary URL on disk.
    func download(_ endpoint: APIEndpoint) async throws -> URL
}

// MARK: - Convenience Defaults

public extension NetworkService {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> NetworkResponse<T> {
        try await request(endpoint, decoder: JSONDecoder())
    }

    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        retryPolicy: RetryPolicy
    ) async throws -> NetworkResponse<T> {
        try await request(endpoint, retryPolicy: retryPolicy, decoder: JSONDecoder())
    }

    func retryableRequest<T: Decodable>(_ endpoint: APIEndpoint) -> RetryableRequest<T> {
        retryableRequest(endpoint, decoder: JSONDecoder())
    }
}
