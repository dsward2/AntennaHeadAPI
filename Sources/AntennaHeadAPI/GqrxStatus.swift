/// Mirrors the "Listen to Gqrx" page's state (`gqrxFormHTML()`): whether Gqrx
/// is running on the Mac, and which UDP port AntennaHead listens on for its
/// audio. Gqrx's own remote-control panel (frequency, mode, gains, squelch,
/// bookmarks) is deliberately not part of this — it stays on the web page,
/// where a pointer and keyboard make it usable.
public struct GqrxStatus: Codable, Sendable {
    public let isRunning: Bool
    /// The port Gqrx's Audio ▸ UDP output has to be pointed at.
    public let receivePort: Int

    public init(isRunning: Bool, receivePort: Int) {
        self.isRunning = isRunning
        self.receivePort = receivePort
    }
}
