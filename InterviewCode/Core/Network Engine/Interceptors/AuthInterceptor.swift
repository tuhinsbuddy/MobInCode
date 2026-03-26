import Foundation

// MARK: - Token Provider

/// Abstracts token storage and refresh so AuthInterceptor stays testable.
public protocol TokenProvider: AnyObject {
    func accessToken() async -> String?
    func refreshToken() async throws -> String
}

// MARK: - Auth Interceptor

/// Injects Bearer tokens into outgoing requests and handles 401 responses
/// by refreshing the token — coordinating concurrent refresh requests so
/// only one refresh network call is made at a time.
///
/// Token Refresh Coordination:
/// If 5 requests all receive a 401 simultaneously, only the first triggers
/// a refresh. The remaining 4 suspend on `pendingContinuations` and resume
/// automatically once the new token is available.
public actor AuthInterceptor: RequestInterceptor {

    private let tokenProvider: TokenProvider

    // Prevents duplicate simultaneous token refreshes
    private var isRefreshing = false
    private var pendingContinuations: [CheckedContinuation<String, Error>] = []

    public init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }

    // MARK: - RequestInterceptor

    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        var mutableRequest = request
        if let token = await tokenProvider.accessToken() {
            mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return mutableRequest
    }

    public func retry(
        _ request: URLRequest,
        dueTo error: NetworkError,
        attemptCount: Int
    ) async -> Bool {
        // Only intercept the first 401 — prevents infinite loops
        guard case .unauthorized = error, attemptCount == 0 else { return false }
        do {
            _ = try await refreshAccessToken()
            return true
        } catch {
            return false
        }
    }

    // MARK: - Coordinated Token Refresh

    private func refreshAccessToken() async throws -> String {
        // If a refresh is already in flight, queue up and await its result
        if isRefreshing {
            return try await withCheckedThrowingContinuation { continuation in
                pendingContinuations.append(continuation)
            }
        }

        isRefreshing = true

        do {
            let newToken = try await tokenProvider.refreshToken()
            isRefreshing = false
            pendingContinuations.forEach { $0.resume(returning: newToken) }
            pendingContinuations.removeAll()
            return newToken
        } catch {
            isRefreshing = false
            pendingContinuations.forEach { $0.resume(throwing: error) }
            pendingContinuations.removeAll()
            throw error
        }
    }
}
