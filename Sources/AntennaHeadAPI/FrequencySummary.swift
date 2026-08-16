import Foundation

/// A client-facing view of a tuned frequency (what the web UI calls a
/// "favorite" — there is no separate favorite record in AntennaHead's
/// database; `favorites.html` just lists `Frequency` rows).
///
/// Deliberately **not** a 1:1 mirror of `AntennaHead.Frequency`
/// (`Services/Database/Records/Frequency.swift`), which carries ~20
/// SDR-tuning-internal fields (tuner gain, FIR size, atan math mode, sample
/// rate, squelch delay, ...). Those are configuration for the Mac's own
/// `rtl_fm_localradio` pipeline, not something a tvOS or watchOS "pick a
/// station and listen" UI has any use for, and exposing them would make
/// every future tuning-internals change on the Mac a breaking change for
/// every client. If a client ever needs to *edit* tuning parameters
/// (equivalent to `editfavorite.html`), that's a good candidate for a
/// separate, explicitly-versioned type rather than widening this one.
public struct FrequencySummary: Codable, Identifiable, Hashable, Sendable {
    public let id: Int64
    public let stationName: String
    /// Pre-formatted for display, e.g. "91.980 MHz" — mirrors
    /// `Frequency.formattedFrequency` so clients never reimplement the
    /// MHz-conversion/formatting rule.
    public let formattedFrequency: String
    public let modulation: String
    public let categoryID: Int64?

    public init(id: Int64, stationName: String, formattedFrequency: String, modulation: String, categoryID: Int64? = nil) {
        self.id = id
        self.stationName = stationName
        self.formattedFrequency = formattedFrequency
        self.modulation = modulation
        self.categoryID = categoryID
    }
}
