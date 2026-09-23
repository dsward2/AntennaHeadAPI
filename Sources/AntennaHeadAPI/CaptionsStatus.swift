/// Mirrors `AntennaHeadHTTPServer.captionsJSON()` — the same polling payload
/// `captions.html`'s own JS consumes (`{"enabled":bool,"live":str,
/// "final":[{"text":str,"announcement":bool},...],"seq":int}`), fed by `SDRController`'s
/// `TranscriptionCaptionListener` off the `PCMTranscriber` tap. Reused as-is
/// here rather than adding a parallel `/api/v1/captions` route — it's
/// already a stable, narrowly-scoped JSON contract with nothing web-specific
/// in its shape.
public struct CaptionsStatus: Codable, Equatable, Sendable {
    /// Whether the `PCMTranscriber` tap is turned on server-side at all
    /// (`Configuration › Speech-to-Text`). `false` means `live`/`final` are
    /// meaningless, not just empty.
    public let enabled: Bool
    /// The current volatile hypothesis — not yet finalized, replaced
    /// wholesale on every update rather than appended to.
    public let live: String
    /// Finalized transcript segments, oldest first.
    public let final: [CaptionLine]
    /// Monotonic counter the server bumps on every finalized segment. Key UI
    /// updates off this instead of `final.count` — once the server's history
    /// ring hits its cap, `final`'s length stops changing even though new
    /// segments keep rolling in and older ones drop off.
    public let seq: Int

    public init(enabled: Bool, live: String, final: [CaptionLine], seq: Int) {
        self.enabled = enabled
        self.live = live
        self.final = final
        self.seq = seq
    }
}

/// One finalized line of the transcript.
///
/// Encodes as `{"text":str,"announcement":bool}`. Decodes a bare string too
/// (as a non-announcement line) — the shape `final` had before announcement
/// lines existed, which `captions.html`'s JS also still accepts — so a
/// client stays compatible with an older server.
public struct CaptionLine: Codable, Equatable, Sendable {
    public let text: String
    /// `true` for the synthesized "Now playing …" marker AntennaHead inserts
    /// on each retune (echoing the spoken announcement), rather than a
    /// transcribed segment. Always the first line of a freshly reset
    /// transcript, so clients style it as a divider between sources.
    public let isAnnouncement: Bool

    public init(text: String, isAnnouncement: Bool = false) {
        self.text = text
        self.isAnnouncement = isAnnouncement
    }

    private enum CodingKeys: String, CodingKey {
        case text
        case isAnnouncement = "announcement"
    }

    public init(from decoder: Decoder) throws {
        if let text = try? decoder.singleValueContainer().decode(String.self) {
            self.init(text: text)
            return
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(text: try container.decode(String.self, forKey: .text),
                  isAnnouncement: try container.decodeIfPresent(Bool.self, forKey: .isAnnouncement) ?? false)
    }
}
