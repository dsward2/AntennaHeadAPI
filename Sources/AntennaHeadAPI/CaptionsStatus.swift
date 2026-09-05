/// Mirrors `AntennaHeadHTTPServer.captionsJSON()` — the same polling payload
/// `captions.html`'s own JS consumes (`{"enabled":bool,"live":str,
/// "final":[str,...],"seq":int}`), fed by `SDRController`'s
/// `TranscriptionCaptionListener` off the `PCMTranscriber` tap. Reused as-is
/// here rather than adding a parallel `/api/v1/captions` route — it's
/// already a stable, narrowly-scoped JSON contract with nothing web-specific
/// in its shape.
public struct CaptionsStatus: Codable, Sendable {
    /// Whether the `PCMTranscriber` tap is turned on server-side at all
    /// (`Configuration › Speech-to-Text`). `false` means `live`/`final` are
    /// meaningless, not just empty.
    public let enabled: Bool
    /// The current volatile hypothesis — not yet finalized, replaced
    /// wholesale on every update rather than appended to.
    public let live: String
    /// Finalized transcript segments, oldest first.
    public let final: [String]
    /// Monotonic counter the server bumps on every finalized segment. Key UI
    /// updates off this instead of `final.count` — once the server's history
    /// ring hits its cap, `final`'s length stops changing even though new
    /// segments keep rolling in and older ones drop off.
    public let seq: Int

    public init(enabled: Bool, live: String, final: [String], seq: Int) {
        self.enabled = enabled
        self.live = live
        self.final = final
        self.seq = seq
    }
}
