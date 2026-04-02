import Foundation

/// Wraps a decoded response with metadata from the HTTP layer.
public struct NetworkResponse<T> {
    public let value: T
    public let httpResponse: HTTPURLResponse
    public let rawData: Data

    public var statusCode: Int              { httpResponse.statusCode }
    public var headers: [AnyHashable: Any]  { httpResponse.allHeaderFields }
}
