/// A client-facing view of a category (`AntennaHead.Category`,
/// `Services/Database/Records/Category.swift`). Same reasoning as
/// `FrequencySummary`: the database record's `scan*` fields configure the
/// Mac's own scan pipeline and aren't meaningful to a remote client beyond
/// "is scanning on for this category" and "how many stations are in it".
public struct CategorySummary: Codable, Identifiable, Hashable, Sendable {
    public let id: Int64
    public let categoryName: String
    public let scanningEnabled: Bool
    public let frequencyCount: Int

    public init(id: Int64, categoryName: String, scanningEnabled: Bool, frequencyCount: Int) {
        self.id = id
        self.categoryName = categoryName
        self.scanningEnabled = scanningEnabled
        self.frequencyCount = frequencyCount
    }
}
