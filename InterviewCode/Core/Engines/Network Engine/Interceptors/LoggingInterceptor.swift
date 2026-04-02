import Foundation
import OSLog

// MARK: - Log Level

public enum LogLevel {
    case none
    case debug    // Status codes and URLs only
    case verbose  // Headers + body
}

// MARK: - Logging Interceptor

/// Logs outgoing requests and incoming responses using OSLog.
/// Verbose mode pretty-prints JSON bodies for readability during development.
public final class LoggingInterceptor: RequestInterceptor {

    private let logLevel: LogLevel
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.networkengine",
        category: "Network"
    )

    public init(logLevel: LogLevel = .debug) {
        self.logLevel = logLevel
    }

    // MARK: - RequestInterceptor

    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        guard logLevel != .none else { return request }
        logRequest(request)
        return request
    }

    public func retry(
        _ request: URLRequest,
        dueTo error: NetworkError,
        attemptCount: Int
    ) async -> Bool {
        guard logLevel != .none else { return false }
        logger.warning("⚠️ Retry \(attemptCount) — \(request.url?.absoluteString ?? "") — \(error.localizedDescription ?? "")")
        return false
    }

    // MARK: - Response Logging (called directly by NetworkServiceImpl)

    func logResponse(data: Data, response: HTTPURLResponse, for request: URLRequest) {
        guard logLevel != .none else { return }
        let emoji = (200...299).contains(response.statusCode) ? "✅" : "❌"
        logger.info("\(emoji) [\(response.statusCode)] \(request.url?.absoluteString ?? "")")

        if logLevel == .verbose {
            logPrettyJSON(data, label: "Response")
        }
    }

    // MARK: - Private

    private func logRequest(_ request: URLRequest) {
        logger.info("➡️ [\(request.httpMethod ?? "?")] \(request.url?.absoluteString ?? "")")

        guard logLevel == .verbose else { return }

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            logger.debug("Headers: \(headers)")
        }
        if let body = request.httpBody {
            logPrettyJSON(body, label: "Request Body")
        }
    }

    private func logPrettyJSON(_ data: Data, label: String) {
        guard
            let json = try? JSONSerialization.jsonObject(with: data),
            let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let string = String(data: pretty, encoding: .utf8)
        else {
            logger.debug("\(label): (non-JSON data, \(data.count) bytes)")
            return
        }
        logger.debug("\(label): \(string)")
    }
}
