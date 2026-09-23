/// The Bonjour (DNS-SD) service AntennaHead advertises for native clients to
/// discover, and the TXT record that rides along with it. Kept here, next to
/// `APIEndpoint`, for the same reason: the server publishes it and every
/// client browses for it, so both sides share one definition instead of
/// agreeing on string literals.
///
/// A dedicated service type rather than the generic `_http._tcp` the web UI
/// is also advertised under (for Safari's Bonjour bookmarks): `_http._tcp`
/// also lists every printer, NAS, and LiveAudioServer's own "AntennaHead
/// Audio" listener on the LAN, so a client browsing it would have to guess
/// by instance name. Only AntennaHead's JSON API listener publishes this
/// type, so every result is a server a client can actually talk to.
///
/// Published on the plain-HTTP listener's port. The TXT record says whether
/// that listener also wants Basic Auth, and which port serves HTTPS (if
/// any), so a client can tell up front whether it can connect rather than
/// discovering it from a failed request.
public struct BonjourAdvertisement: Equatable, Sendable {
    /// DNS-SD service type, without the trailing domain.
    public static let serviceType = "_antennahead._tcp"

    /// TXT record keys (RFC 6763 §6: short, lowercase ASCII).
    public enum Key {
        /// JSON API major version, matching the `v1` in `APIEndpoint`'s paths.
        public static let apiVersion = "api"
        /// `"1"` when the listener requires HTTP Basic Auth, `"0"` otherwise.
        public static let auth = "auth"
        /// The HTTPS listener's port. Omitted when HTTPS is off.
        public static let httpsPort = "https"
    }

    /// The API version this build of the package speaks.
    public static let currentAPIVersion = 1

    public var apiVersion: Int
    public var requiresAuth: Bool
    public var httpsPort: UInt16?

    public init(apiVersion: Int = BonjourAdvertisement.currentAPIVersion,
                requiresAuth: Bool,
                httpsPort: UInt16?) {
        self.apiVersion = apiVersion
        self.requiresAuth = requiresAuth
        self.httpsPort = httpsPort
    }

    /// Parses a received TXT record. Missing or malformed keys fall back to
    /// the most permissive reading (API v1, no auth, no HTTPS) so a server
    /// that predates a key still shows up rather than vanishing from the list.
    public init(txtRecord: [String: String]) {
        apiVersion = txtRecord[Key.apiVersion].flatMap(Int.init) ?? 1
        requiresAuth = txtRecord[Key.auth] == "1"
        httpsPort = txtRecord[Key.httpsPort].flatMap(UInt16.init)
    }

    /// The TXT record to publish.
    public var txtRecord: [String: String] {
        var record = [
            Key.apiVersion: String(apiVersion),
            Key.auth: requiresAuth ? "1" : "0",
        ]
        if let httpsPort {
            record[Key.httpsPort] = String(httpsPort)
        }
        return record
    }
}
