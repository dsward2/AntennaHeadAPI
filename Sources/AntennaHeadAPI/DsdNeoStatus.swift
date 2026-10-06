/// ControlBooth's dsd-neo Scanner, as the JSON API reports it — the same
/// state the web Remote Control page's dsd-neo section shows. The scanner
/// follows one trunked system at a time; a "configuration" is a system the
/// user saved in ControlBooth (AWIN, CWIN, …) with the control channels it is
/// known to use.
public struct DsdNeoStatus: Codable, Sendable, Equatable {
    /// One control channel of a configuration.
    public struct ControlChannel: Codable, Sendable, Equatable, Hashable {
        public let hz: Int
        /// The site that carries it ("Clearwell Road"); may be empty.
        public let label: String

        public init(hz: Int, label: String) {
            self.hz = hz
            self.label = label
        }

        /// "854.3625 MHz — Clearwell Road".
        public var title: String {
            let frequency = String(format: "%.4f", Double(hz) / 1_000_000)
                .replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"\.$"#, with: "", options: .regularExpression)
            return label.isEmpty ? "\(frequency) MHz" : "\(frequency) MHz — \(label)"
        }
    }

    public struct Configuration: Codable, Sendable, Equatable, Identifiable {
        public let id: String
        public let name: String
        public let controlChannels: [ControlChannel]
        /// The control channel the configuration is set to.
        public let selectedControlChannelHz: Int

        public init(id: String, name: String, controlChannels: [ControlChannel], selectedControlChannelHz: Int) {
            self.id = id
            self.name = name
            self.controlChannels = controlChannels
            self.selectedControlChannelHz = selectedControlChannelHz
        }
    }

    /// Whether ControlBooth is running. Everything else is empty or false
    /// when it isn't, or when it predates the dsd-neo Scanner.
    public let isRunning: Bool
    public let installed: Bool
    /// Whether the scanner has a dongle and a control channel to start with.
    public let configured: Bool
    /// "idle", "running", "restarting" or "failed".
    public let state: String
    /// Why it is restarting or failed.
    public let message: String?
    /// The scanner's ControlBooth pipeline, to start with
    /// `StartControlBoothPipelineRequest` (Listen) or stop with
    /// `controlBoothStop`; nil when ControlBooth has none.
    public let pipelineName: String?
    /// Whether AntennaHead is playing the scanner right now.
    public let isListening: Bool
    /// "scan", "allowList" or "hold".
    public let mode: String
    /// The talkgroup most recently heard, e.g. "Little Rock Fire (TG 3)".
    public let talkgroupText: String?
    /// The network the scanner identified ("BEE00-188").
    public let systemID: String?
    public let controlChannelHz: Int
    public let configurations: [Configuration]
    public let activeConfigurationID: String?

    public var isActive: Bool { state == "running" || state == "restarting" }

    public var activeConfiguration: Configuration? {
        configurations.first { $0.id == activeConfigurationID }
    }

    public init(isRunning: Bool, installed: Bool = false, configured: Bool = false, state: String = "idle",
                message: String? = nil, pipelineName: String? = nil, isListening: Bool = false,
                mode: String = "scan", talkgroupText: String? = nil, systemID: String? = nil,
                controlChannelHz: Int = 0, configurations: [Configuration] = [],
                activeConfigurationID: String? = nil) {
        self.isRunning = isRunning
        self.installed = installed
        self.configured = configured
        self.state = state
        self.message = message
        self.pipelineName = pipelineName
        self.isListening = isListening
        self.mode = mode
        self.talkgroupText = talkgroupText
        self.systemID = systemID
        self.controlChannelHz = controlChannelHz
        self.configurations = configurations
        self.activeConfigurationID = activeConfigurationID
    }
}

/// Request body for `APIEndpoint.dsdNeoConfiguration`.
public struct SetDsdNeoConfigurationRequest: Codable, Sendable {
    /// A `DsdNeoStatus.Configuration.id`.
    public let configurationID: String
    /// One of that configuration's control channels; nil keeps the one it
    /// last used.
    public let controlChannelHz: Int?

    public init(configurationID: String, controlChannelHz: Int? = nil) {
        self.configurationID = configurationID
        self.controlChannelHz = controlChannelHz
    }
}
