// swift-tools-version: 5.9
import PackageDescription

// AntennaHeadAPI — the Codable data contract between AntennaHead's HTTP
// server and any non-WebKit client (tvOS app, watchOS app; iOS/macOS native
// clients could adopt it too). AntennaHead's server imports this package to
// encode responses; native SwiftUI clients import the same package to decode
// them, so a schema change is a compile error on every client instead of a
// runtime mismatch discovered in the field.
//
// Deliberately has no dependency on GRDB or any other AntennaHead-internal
// type: the types here are purpose-built client-facing summaries (see
// FrequencySummary's doc comment), not Codable reuse of the database
// records, so this package stays a lightweight leaf dependency any target on
// any Apple platform can adopt.
let package = Package(
    name: "AntennaHeadAPI",
    platforms: [
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(name: "AntennaHeadAPI", targets: ["AntennaHeadAPI"])
    ],
    targets: [
        .target(name: "AntennaHeadAPI"),
        .testTarget(name: "AntennaHeadAPITests", dependencies: ["AntennaHeadAPI"])
    ]
)
