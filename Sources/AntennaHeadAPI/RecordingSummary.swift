import Foundation

/// A file in AntennaHead's shared Recordings folder (mirrors
/// `recordingsListHTML()`'s listing).
///
/// Deliberately carries `downloadPath` rather than leaving clients to
/// reconstruct it: playback is meant to go through AntennaHead's existing
/// `/recordings-download/<filename>` route (Range-capable, so a client's
/// native player gets a real seek bar — see that route's doc comment in
/// `AntennaHeadHTTPServer` for why it's the better fit here than the
/// live-pipeline "Listen" flow the web UI also offers), and the exact
/// percent-encoding/prefix convention for that route is server knowledge, not
/// something worth duplicating in every client.
public struct RecordingSummary: Codable, Identifiable, Hashable, Sendable {
    public var id: String { fileName }
    public let fileName: String
    public let modifiedAt: Date
    /// Host-relative path — combine with the client's own `http://<host>`
    /// base, same as every other endpoint in this package.
    public let downloadPath: String

    public init(fileName: String, modifiedAt: Date, downloadPath: String) {
        self.fileName = fileName
        self.modifiedAt = modifiedAt
        self.downloadPath = downloadPath
    }
}
