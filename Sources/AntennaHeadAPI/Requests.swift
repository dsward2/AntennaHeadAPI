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
