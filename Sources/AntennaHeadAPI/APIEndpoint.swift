/// Route paths for the JSON API, kept as named constants (not string
/// literals scattered at each call site) so the server and every client
/// share one place they can drift-check against each other.
///
/// Namespaced under `/api/v1/...`, distinct from every existing route in
/// `AntennaHeadHTTPServer`'s big `switch` (the `*.html` fragment routes,
/// and the pre-existing `/api/aac-recorder/*` routes) — adding these is
/// meant to be a strictly additive change with zero collision risk against
/// the current web UI. `v1` is deliberately in the path rather than only in
/// a response field: it lets a future incompatible v2 be served
/// side-by-side during a client migration instead of forcing a flag day.
public enum APIEndpoint {
    public static let categories = "/api/v1/categories"
    public static let favorites = "/api/v1/favorites"
    public static let nowPlaying = "/api/v1/now-playing"
    public static let tune = "/api/v1/tune"
    public static let startScan = "/api/v1/scan/start"
    public static let stop = "/api/v1/stop"
    public static let recorderStatus = "/api/v1/recorder/status"

    public static let devices = "/api/v1/devices"
    public static let startDevice = "/api/v1/devices/start"

    public static let recordings = "/api/v1/recordings"

    public static let controlBoothStatus = "/api/v1/controlbooth/status"
    public static let controlBoothLaunch = "/api/v1/controlbooth/launch"
    public static let controlBoothStart = "/api/v1/controlbooth/start"
    public static let controlBoothStop = "/api/v1/controlbooth/stop"

    public static let spatialAudio = "/api/v1/spatial-audio"
    public static let setSpatialAudio = "/api/v1/spatial-audio/set"

    /// Deliberately *not* under `/api/v1` — this is the pre-existing
    /// `captions.html` polling route (`AntennaHeadHTTPServer.captionsJSON()`),
    /// reused as-is rather than duplicated under the versioned namespace.
    public static let captions = "/captions.json"
}

/// Schema version this build of `AntennaHeadAPI` implements. Intended to
/// ride alongside `NowPlayingStatus` and similar responses (e.g. as an HTTP
/// response header, `X-AntennaHeadAPI-Version`) so an older client build can
/// detect a server that has moved on, rather than failing an opaque decode.
/// Not yet wired into any response — left as a single source of truth for
/// when that wiring happens.
public enum APIVersion {
    public static let current = 1
}
