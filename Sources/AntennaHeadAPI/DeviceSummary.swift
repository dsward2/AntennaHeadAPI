/// A Core Audio input device AntennaHead can listen to (mirrors
/// `AudioInputDevices.names()` — devices/entitlements are Mac-local, so this
/// list can only ever reflect what the Mac itself reports, not something a
/// remote client could enumerate on its own).
public struct DeviceSummary: Codable, Identifiable, Hashable, Sendable {
    /// The device name doubles as its identifier — matches how
    /// `startTasksForDevice(deviceName:...)` already selects a device by
    /// name rather than a stable numeric ID (Core Audio device IDs aren't
    /// persistent across reboots/reconnects, names are what the web UI's
    /// picker already keys off).
    public var id: String { name }
    public let name: String

    public init(name: String) {
        self.name = name
    }
}
