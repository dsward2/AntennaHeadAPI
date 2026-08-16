/// What `SDRController` is currently doing. Mirrors
/// `AntennaHead.SDRController.TaskMode` (`Services/SDRController.swift`) —
/// kept as an independent declaration rather than a shared dependency so
/// this package never needs to import anything AntennaHead-internal; the
/// server is responsible for keeping the two enums' cases in sync (a
/// `switch` without `default` on either side will fail to compile if they
/// drift, which is the intended guardrail).
public enum TaskMode: String, Codable, Sendable, CaseIterable {
    case stopped
    case frequency
    case scan
    case device
    case customTask
    case recording
}
