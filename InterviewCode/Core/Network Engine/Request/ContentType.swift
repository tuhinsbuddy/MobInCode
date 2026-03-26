import Foundation

/// HTTP Content-Type values.
public enum ContentType {
    case json
    case formURLEncoded
    case multipartFormData(boundary: String)
    case xml
    case plain
    case none

    var headerValue: String {
        switch self {
        case .json:                             return "application/json"
        case .formURLEncoded:                   return "application/x-www-form-urlencoded"
        case .multipartFormData(let boundary):  return "multipart/form-data; boundary=\(boundary)"
        case .xml:                              return "application/xml"
        case .plain:                            return "text/plain"
        case .none:                             return ""
        }
    }
}
