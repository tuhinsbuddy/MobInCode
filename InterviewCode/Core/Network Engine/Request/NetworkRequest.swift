import Foundation

/// Builds a URLRequest from an APIEndpoint.
public enum NetworkRequest {

    public static func build(from endpoint: APIEndpoint) throws -> URLRequest {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(
            url: url,
            cachePolicy: endpoint.cachePolicy,
            timeoutInterval: endpoint.timeoutInterval
        )
        request.httpMethod = endpoint.method.rawValue

        // Default accept header
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Content-Type (skip for .none)
        if case .none = endpoint.contentType {} else {
            request.setValue(endpoint.contentType.headerValue, forHTTPHeaderField: "Content-Type")
        }

        // Custom headers (may override defaults)
        endpoint.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Encode body
        if let body = endpoint.body {
            switch endpoint.contentType {
            case .json:
                do {
                    request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
                } catch {
                    throw NetworkError.encodingFailed(error)
                }
            case .formURLEncoded:
                if let dict = body as? [String: String] {
                    request.httpBody = dict
                        .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.value)" }
                        .joined(separator: "&")
                        .data(using: .utf8)
                }
            default:
                break
            }
        }

        return request
    }
}

// MARK: - Type-Erased Encodable

/// Wraps any Encodable so it can be passed to JSONEncoder generically.
struct AnyEncodable: Encodable {
    private let encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
