/// Mirrors `controlBoothPageHTML()`'s state: whether ControlBooth is running
/// on the Mac at all, and if so, which pipelines it has configured. Pipeline
/// names double as their identifiers in `StartControlBoothPipelineRequest`,
/// matching `controlBoothListenButtonClicked`'s `pipeline_select` form field
/// — ControlBooth's own pipelines aren't exposed to AntennaHead by numeric
/// ID, only by name (`ControlBoothClient.pipelines() -> [String]`).
public struct ControlBoothStatus: Codable, Sendable {
    public let isRunning: Bool
    public let pipelineNames: [String]
    /// The ControlBooth pipeline AntennaHead is currently listening to (the
    /// name shown as the station while ControlBooth is the source), or `nil`
    /// when none is. Optional so older servers/clients that omit it still
    /// decode.
    public let activePipelineName: String?
    /// Whether ControlBooth's AirPlay Receiver is on at all (advertising and
    /// decoding, independent of whether it's relaying to AntennaHead). `nil`
    /// when `isRunning` is `false`, or an older ControlBooth couldn't be
    /// asked. Optional so older servers/clients that predate the AirPlay
    /// receiver still decode.
    public let airPlayEnabled: Bool?
    /// Whether ControlBooth's AirPlay Receiver is currently relaying decoded
    /// PCM to AntennaHead — the state the "airplay/start"/"airplay/stop"
    /// endpoints toggle.
    public let airPlayRelayEnabled: Bool?
    /// Whether an AirPlay client is actively streaming right now, as opposed
    /// to the receiver just advertising/idle.
    public let airPlayReceivingAudio: Bool?

    /// The `activePipelineName` AntennaHead reports while it's listening to
    /// ControlBooth's AirPlay Receiver (which isn't a saved pipeline). Must
    /// match ControlBooth's `AirPlayReceiverService.antennaHeadTaskName`.
    public static let airPlaySourceName = "AirPlay Receiver"

    /// Whether AntennaHead is currently listening to the AirPlay Receiver —
    /// what decides Listen vs. Stop, like the web UI's ControlBooth page.
    public var isListeningToAirPlay: Bool {
        activePipelineName == Self.airPlaySourceName
    }

    public init(isRunning: Bool, pipelineNames: [String], activePipelineName: String? = nil,
               airPlayEnabled: Bool? = nil, airPlayRelayEnabled: Bool? = nil, airPlayReceivingAudio: Bool? = nil) {
        self.isRunning = isRunning
        self.pipelineNames = pipelineNames
        self.activePipelineName = activePipelineName
        self.airPlayEnabled = airPlayEnabled
        self.airPlayRelayEnabled = airPlayRelayEnabled
        self.airPlayReceivingAudio = airPlayReceivingAudio
    }
}
