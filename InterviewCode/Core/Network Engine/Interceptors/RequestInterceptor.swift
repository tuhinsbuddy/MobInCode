import Foundation

/// An interceptor can inspect and modify requests before they are sent,
/// and decide whether to retry them after a failure.
///
/// Chain multiple interceptors to compose behaviours (auth, logging, analytics).
public protocol RequestInterceptor {
    /// Mutate or enrich the outgoing URLRequest (e.g., inject auth headers).
    func adapt(_ request: URLRequest) async throws -> URLRequest

    /// Called after a request fails. Return `true` to trigger a retry.
    func retry(
        _ request: URLRequest,
        dueTo error: NetworkError,
        attemptCount: Int
    ) async -> Bool
}

public extension RequestInterceptor {
    func retry(
        _ request: URLRequest,
        dueTo error: NetworkError,
        attemptCount: Int
    ) async -> Bool { false }
}
