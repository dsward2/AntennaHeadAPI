/// Mirrors the `{"error": message}` shape
/// `AntennaHeadHTTPServer.jsonErrorResponse(_:status:)` already returns
/// today, so error decoding doesn't need a second, ad hoc shape alongside
/// the success types in this package.
public struct APIError: Codable, Error, Sendable {
    public let error: String

    public init(_ message: String) {
        self.error = message
    }
}
