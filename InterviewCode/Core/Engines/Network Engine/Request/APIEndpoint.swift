import Foundation

/// Defines a type-safe contract for API endpoints.
/// Conform this protocol in a feature-level enum to describe all requests.
///
/// Example:
/// ```swift
/// enum UserEndpoint: APIEndpoint {
///     case getProfile(id: String)
///     case updateProfile(User)
///
///     var baseURL: URL { URL(string: "https://api.example.com")! }
///
///     var path: String {
///         switch self {
///         case .getProfile(let id): return "/users/\(id)"
///         case .updateProfile:      return "/users/me"
///         }
///     }
///
///     var method: HTTPMethod {
///         switch self {
///         case .getProfile:    return .GET
///         case .updateProfile: return .PUT
///         }
///     }
///
///     var body: Encodable? {
///         switch self {
///         case .updateProfile(let user): return user
///         default: return nil
///         }
///     }
/// }
/// ```
public protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var body: Encodable? { get }
    var contentType: ContentType { get }
    var requiresAuth: Bool { get }
    var timeoutInterval: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

public extension APIEndpoint {
    var headers: [String: String]?          { nil }
    var queryParameters: [String: String]?  { nil }
    var body: Encodable?                    { nil }
    var contentType: ContentType            { .json }
    var requiresAuth: Bool                  { true }
    var timeoutInterval: TimeInterval       { 30 }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }

    /// Assembles the full URL including query parameters.
    var url: URL? {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else { return nil }

        if let params = queryParameters, !params.isEmpty {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components.url
    }
}
