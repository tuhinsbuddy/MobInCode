import Foundation

/// Typed errors for all network failures.
public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noInternetConnection
    case timeout
    case unauthorized(data: Data?)
    case forbidden
    case notFound
    case serverError(statusCode: Int, data: Data?)
    case decodingFailed(Error)
    case encodingFailed(Error)
    case cancelled
    case maxRetriesExceeded
    case unknown(Error?)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:                   return "The URL is invalid."
        case .noInternetConnection:         return "No internet connection available."
        case .timeout:                      return "The request timed out."
        case .unauthorized:                 return "Unauthorized. Please sign in again."
        case .forbidden:                    return "Access to this resource is forbidden."
        case .notFound:                     return "The requested resource was not found."
        case .serverError(let code, _):     return "Server error with status code: \(code)."
        case .decodingFailed(let error):    return "Decoding failed: \(error.localizedDescription)"
        case .encodingFailed(let error):    return "Encoding failed: \(error.localizedDescription)"
        case .cancelled:                    return "The request was cancelled."
        case .maxRetriesExceeded:           return "Maximum retry attempts exceeded."
        case .unknown(let error):           return error?.localizedDescription ?? "An unknown error occurred."
        }
    }

    /// Maps an HTTP status code to a typed NetworkError.
    static func map(statusCode: Int, data: Data?) -> NetworkError {
        switch statusCode {
        case 401: return .unauthorized(data: data)
        case 403: return .forbidden
        case 404: return .notFound
        default:  return .serverError(statusCode: statusCode, data: data)
        }
    }
}
