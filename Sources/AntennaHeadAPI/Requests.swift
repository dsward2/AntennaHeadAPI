/// Request body for tuning to a specific frequency — the JSON-API
/// equivalent of `/frequencylistenbuttonclicked.html`'s form POST
/// (`AntennaHeadHTTPServer.frequencyID(fromListenBody:)`).
public struct TuneFrequencyRequest: Codable, Sendable {
    public let frequencyID: Int64

    public init(frequencyID: Int64) {
        self.frequencyID = frequencyID
    }
}

/// Request body for starting a category scan — the JSON-API equivalent of
/// `/scannerlistenbuttonclicked.html`.
public struct StartCategoryScanRequest: Codable, Sendable {
    public let categoryID: Int64

    public init(categoryID: Int64) {
        self.categoryID = categoryID
    }
}

/// Request body for listening to a Core Audio input device — the JSON-API
/// equivalent of `/devicelistenbuttonclicked.html`'s form POST.
/// `audioOutputFilter` defaults to `"vol 1"` (the web form's own default,
/// applied by Sox to the final output) since a Sox filter string isn't
/// something worth typing on a Siri Remote/Watch keyboard — a client that
/// wants to expose it can still override the default.
public struct StartDeviceRequest: Codable, Sendable {
    public let deviceName: String
    public let audioOutputFilter: String

    public init(deviceName: String, audioOutputFilter: String = "vol 1") {
        self.deviceName = deviceName
        self.audioOutputFilter = audioOutputFilter
    }
}

/// Request body for starting a ControlBooth pipeline — the JSON-API
/// equivalent of `/controlboothlistenbuttonclicked.html`'s `pipeline_select`
/// form field.
public struct StartControlBoothPipelineRequest: Codable, Sendable {
    public let pipelineName: String

    public init(pipelineName: String) {
        self.pipelineName = pipelineName
    }
}
