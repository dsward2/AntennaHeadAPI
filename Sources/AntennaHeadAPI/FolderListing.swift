import Foundation

/// The contents of one of AntennaHead's configured source folders — the Play
/// Audio Files folder or the Text to Speech folder. Both folders are chosen in
/// AntennaHead's Configuration tab on the Mac (a folder chooser can't be shown
/// to a remote client), so a client can only list and pick from what's there.
public struct FolderListing: Codable, Sendable {
    /// `false` when no folder has been chosen yet, or its saved bookmark no
    /// longer resolves. `files` and `playlists` are then empty.
    public let folderConfigured: Bool
    /// The folder's path on the Mac, for display only.
    public let folderPath: String?
    /// Playable files, sorted by name.
    public let files: [FolderFile]
    /// Playlist files (.m3u/.m3u8) in the folder, sorted by name. Always
    /// empty for the Text to Speech folder.
    public let playlists: [String]

    public init(folderConfigured: Bool, folderPath: String?, files: [FolderFile], playlists: [String] = []) {
        self.folderConfigured = folderConfigured
        self.folderPath = folderPath
        self.files = files
        self.playlists = playlists
    }
}

/// One file in a `FolderListing`. The name doubles as its ID, the same as the
/// web form's checkbox values.
public struct FolderFile: Codable, Identifiable, Hashable, Sendable {
    public var id: String { name }
    public let name: String
    public let modifiedAt: Date
    public let size: Int64

    public init(name: String, modifiedAt: Date, size: Int64) {
        self.name = name
        self.modifiedAt = modifiedAt
        self.size = size
    }
}

/// Play order for Play Audio Files and Text to Speech — the web forms'
/// Sequence popup. Raw values match `SDRController`'s own sequence enums.
public enum FileSequence: String, Codable, Sendable, CaseIterable {
    /// Oldest file first, by modification date.
    case chronological
    /// By file name.
    case alphabetical
    case random
}
