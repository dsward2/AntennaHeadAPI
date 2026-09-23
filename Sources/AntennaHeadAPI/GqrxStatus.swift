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

/// One of Gqrx's own bookmarks (mirrors `GqrxBookmark`, from Gqrx's
/// `\get_bookmarks` remote-control command, which needs a Gqrx build carrying
/// PR #1464). The frequency doubles as its ID, the same as the web page's
/// Tune buttons.
public struct GqrxBookmarkSummary: Codable, Identifiable, Hashable, Sendable {
    public var id: Int64 { frequencyHz }
    public let frequencyHz: Int64
    public let name: String
    /// Gqrx's demodulator name, e.g. "WFM (stereo)" or "Narrow FM".
    public let modulation: String
    public let bandwidthHz: Int
    public let tags: [String]

    public init(frequencyHz: Int64, name: String, modulation: String, bandwidthHz: Int, tags: [String]) {
        self.frequencyHz = frequencyHz
        self.name = name
        self.modulation = modulation
        self.bandwidthHz = bandwidthHz
        self.tags = tags
    }
}
