import Foundation

/// Mirrors the shape `AntennaHeadHTTPServer.aacRecorderStatusResponse()`
/// already returns as JSON today (`/api/aac-recorder/status`) — this is the
/// one existing endpoint whose response this package's type matches
/// as-is rather than redesigning, since it was already a clean, minimal
/// client-facing shape and not a flattened database record.
public struct AACRecorderStatus: Codable, Sendable {
    public let isRecording: Bool
    public let startedAt: Date?

    public init(isRecording: Bool, startedAt: Date?) {
        self.isRecording = isRecording
        self.startedAt = startedAt
    }
}
