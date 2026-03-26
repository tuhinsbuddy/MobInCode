import Foundation

/// Builds multipart/form-data request bodies.
///
/// Use this to upload files, images, or mixed form+binary data.
///
/// Usage:
/// ```swift
/// var form = MultipartFormData()
/// form.addTextField(named: "username", value: "tuhin")
/// form.addDataField(named: "avatar", data: imageData, fileName: "avatar.jpg", mimeType: "image/jpeg")
/// let body = form.build()
/// ```
public struct MultipartFormData {

    public let boundary: String
    private var body = Data()

    public init(boundary: String = "Boundary-\(UUID().uuidString)") {
        self.boundary = boundary
    }

    // MARK: - Adding Fields

    /// Appends a plain-text form field.
    public mutating func addTextField(named name: String, value: String) {
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        append("\(value)\r\n")
    }

    /// Appends a binary data field (file, image, etc.).
    public mutating func addDataField(
        named name: String,
        data: Data,
        fileName: String,
        mimeType: String
    ) {
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        append("\r\n")
    }

    // MARK: - Build

    /// Returns the fully assembled multipart body data.
    public func build() -> Data {
        var finalData = body
        finalData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return finalData
    }

    // MARK: - Private

    private mutating func append(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        body.append(data)
    }
}
