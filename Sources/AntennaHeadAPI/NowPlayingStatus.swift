/// Replaces the ad hoc `[String: Any]` dictionary
/// `AntennaHeadHTTPServer.nowPlayingStatusJSON()` builds today for
/// `/nowplayingstatus.html`. That endpoint's JSON is really the full
/// `Frequency` record fields (`tuner_gain`, `fir_size`, `atan_math`, ...)
/// flattened alongside status — fine for a page that's about to re-render
/// itself from the same data, wrong shape for a client that just wants to
/// know "what's playing, how strong is it, is anything playing at all".
///
/// `stationName`/`statusText` intentionally stay separate rather than one
/// "now playing" string: `nowPlayingStatusJSON()`'s current behavior falls
/// back to `sdrController.statusFunction` (e.g. "No active tuning") as the
/// station name when nothing is playing, which reads oddly in a UI that
/// wants to show a station name field distinct from a status line.
public struct NowPlayingStatus: Codable, Sendable {
    public let taskMode: TaskMode
    public let stationName: String
    public let formattedFrequency: String?
    public let statusText: String
    /// Raw RMS signal level from `SDRController.signalLevel`. Left as the
    /// server's native unit rather than normalized to 0...1 here — clients
    /// that want a meter can decide their own scaling, and normalizing
    /// server-side would silently bake in a specific device's dynamic range.
    public let signalLevel: Int

    public init(taskMode: TaskMode, stationName: String, formattedFrequency: String?, statusText: String, signalLevel: Int) {
        self.taskMode = taskMode
        self.stationName = stationName
        self.formattedFrequency = formattedFrequency
        self.statusText = statusText
        self.signalLevel = signalLevel
    }
}
