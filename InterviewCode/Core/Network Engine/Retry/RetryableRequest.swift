import Foundation

/// Wraps a network operation to support explicit manual retries.
///
/// Use this when you want to give the caller (e.g. a ViewModel) control
/// over when to retry, such as after showing a user-facing error alert.
///
/// Usage:
/// ```swift
/// var retryable = networkService.retryableRequest(UserEndpoint.getProfile(id: "1"))
/// do {
///     let response: NetworkResponse<User> = try await retryable.retry()
/// } catch {
///     // Show alert — user taps "Try Again" → call retryable.retry() again
/// }
/// ```
public struct RetryableRequest<T: Decodable> {
    private let operation: () async throws -> NetworkResponse<T>

    /// Number of times `retry()` has been called.
    public private(set) var attemptCount: Int = 0

    init(operation: @escaping () async throws -> NetworkResponse<T>) {
        self.operation = operation
    }

    /// Executes (or re-executes) the request.
    public mutating func retry() async throws -> NetworkResponse<T> {
        attemptCount += 1
        return try await operation()
    }
}
