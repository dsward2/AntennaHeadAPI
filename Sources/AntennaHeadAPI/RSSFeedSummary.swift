/// A subscribed feed on the Speak RSS Headlines page (mirrors
/// `rssFeedsTableHTML()`'s rows). Feed management (add, edit, delete, OPML
/// import) and per-feed voices stay on the web page.
public struct RSSFeedSummary: Codable, Identifiable, Hashable, Sendable {
    public let id: Int64
    public let name: String
    public let feedURL: String

    public init(id: Int64, name: String, feedURL: String) {
        self.id = id
        self.name = name
        self.feedURL = feedURL
    }
}
