/// Mirrors `airPlayPageHTML()`'s state. `isRunning` reflects the AirPlay
/// *capture* pipeline (toggled only in AntennaHead's own Configuration tab —
/// there is deliberately no remote "enable" action, matching the web page,
/// which shows "Enable AirPlay Receiver in the Configuration tab first"
/// instead of a button when it's off). When `isRunning` is true, a client
/// can still call `/api/v1/airplay/listen` to route that capture to the live
/// stream, or `/api/v1/airplay/stop`.
public struct AirPlayReceiverStatus: Codable, Sendable {
    public let isRunning: Bool
    public let lastError: String?

    public init(isRunning: Bool, lastError: String?) {
        self.isRunning = isRunning
        self.lastError = lastError
    }
}
