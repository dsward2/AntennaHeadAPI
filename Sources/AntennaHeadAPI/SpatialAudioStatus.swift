/// Current spatial-audio state, returned by `APIEndpoint.spatialAudio` and
/// after a `APIEndpoint.setSpatialAudio` call. `enabled` mirrors
/// `SDRController.spatialAudioEnabled` (the Configuration tab's toggle) —
/// a client should hide or disable its own controls when this is false,
/// same as the web UI's `spatialAudioControlsHTML()` renders nothing in
/// that case rather than a set of sliders with nothing listening to them.
///
/// `azimuth`/`elevation`/`distance` use the same units and convention as
/// every other spatial-audio surface in this app: degrees (0 = front,
/// clockwise-positive) and pad units (1.0 = reference/full level) — see
/// `PCMBinauralPanner`'s own header comment for where that convention
/// originates.
public struct SpatialAudioStatus: Codable, Sendable {
    public let enabled: Bool
    public let azimuth: Double
    public let elevation: Double
    public let distance: Double

    public init(enabled: Bool, azimuth: Double, elevation: Double, distance: Double) {
        self.enabled = enabled
        self.azimuth = azimuth
        self.elevation = elevation
        self.distance = distance
    }
}
