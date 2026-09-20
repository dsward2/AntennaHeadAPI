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

    public init(isRunning: Bool, pipelineNames: [String], activePipelineName: String? = nil) {
        self.isRunning = isRunning
        self.pipelineNames = pipelineNames
        self.activePipelineName = activePipelineName
    }
}
