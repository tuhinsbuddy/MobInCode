import Foundation

/// Configures how and when the network layer should automatically retry a failed request.
public struct RetryPolicy {
    /// Maximum number of retry attempts.
    public let maxRetries: Int

    /// Base delay (in seconds) between retries.
    public let retryDelay: TimeInterval

    /// HTTP status codes that should trigger a retry.
    public let retryableStatusCodes: Set<Int>

    /// If true, delay doubles with each attempt (exponential backoff).
    public let useExponentialBackoff: Bool

    /// Adds a random offset to the delay to avoid thundering-herd issues.
    public let jitter: Bool

    public init(
        maxRetries: Int = 3,
        retryDelay: TimeInterval = 1.0,
        retryableStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504],
        useExponentialBackoff: Bool = true,
        jitter: Bool = true
    ) {
        self.maxRetries = maxRetries
        self.retryDelay = retryDelay
        self.retryableStatusCodes = retryableStatusCodes
        self.useExponentialBackoff = useExponentialBackoff
        self.jitter = jitter
    }

    // MARK: - Presets

    /// Balanced retry policy (3 retries, exponential backoff, jitter).
    public static let `default` = RetryPolicy()

    /// No retries.
    public static let none = RetryPolicy(
        maxRetries: 0,
        retryDelay: 0,
        retryableStatusCodes: [],
        useExponentialBackoff: false,
        jitter: false
    )

    /// Aggressive retry for critical requests (5 retries, short base delay).
    public static let aggressive = RetryPolicy(
        maxRetries: 5,
        retryDelay: 0.5,
        useExponentialBackoff: true,
        jitter: true
    )

    // MARK: - Helpers

    /// Calculates the delay for a given retry attempt number (0-indexed).
    func delay(for attempt: Int) -> TimeInterval {
        var delay = useExponentialBackoff
            ? retryDelay * pow(2.0, Double(attempt))
            : retryDelay

        if jitter {
            delay += Double.random(in: 0...0.5)
        }
        return delay
    }

    /// Returns true if the given error warrants an automatic retry.
    func shouldRetry(error: NetworkError) -> Bool {
        switch error {
        case .timeout, .noInternetConnection:
            return true
        case .serverError(let statusCode, _):
            return retryableStatusCodes.contains(statusCode)
        default:
            return false
        }
    }
}
