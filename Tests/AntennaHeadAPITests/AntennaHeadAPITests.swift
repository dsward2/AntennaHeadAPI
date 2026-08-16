import XCTest
@testable import AntennaHeadAPI

/// Round-trip encode/decode coverage for every DTO. Deliberately simple —
/// the value of these tests isn't exercising edge cases, it's making sure a
/// future field rename or type change that breaks `Codable` conformance
/// (e.g. an accidental non-optional-to-optional change without a custom
/// `init(from:)`) is caught here rather than only at a client's decode call
/// site.
final class AntennaHeadAPITests: XCTestCase {
    func testFrequencySummaryRoundTrips() throws {
        let value = FrequencySummary(id: 42, stationName: "KUAR", formattedFrequency: "91.980 MHz", modulation: "fm", categoryID: 3)
        let decoded = try JSONDecoder().decode(FrequencySummary.self, from: JSONEncoder().encode(value))
        XCTAssertEqual(decoded, value)
    }

    func testCategorySummaryRoundTrips() throws {
        let value = CategorySummary(id: 1, categoryName: "Public Radio", scanningEnabled: true, frequencyCount: 5)
        let decoded = try JSONDecoder().decode(CategorySummary.self, from: JSONEncoder().encode(value))
        XCTAssertEqual(decoded, value)
    }

    func testNowPlayingStatusRoundTrips() throws {
        let value = NowPlayingStatus(taskMode: .frequency, stationName: "KUAR", formattedFrequency: "91.980 MHz", statusText: "Playing", signalLevel: 62)
        let decoded = try JSONDecoder().decode(NowPlayingStatus.self, from: JSONEncoder().encode(value))
        XCTAssertEqual(decoded.taskMode, .frequency)
        XCTAssertEqual(decoded.stationName, "KUAR")
        XCTAssertEqual(decoded.signalLevel, 62)
    }

    func testNowPlayingStatusEncodesNilFrequencyAsNull() throws {
        let value = NowPlayingStatus(taskMode: .stopped, stationName: "Not Playing", formattedFrequency: nil, statusText: "No active tuning", signalLevel: 0)
        let decoded = try JSONDecoder().decode(NowPlayingStatus.self, from: JSONEncoder().encode(value))
        XCTAssertNil(decoded.formattedFrequency)
    }

    func testAACRecorderStatusRoundTrips() throws {
        let value = AACRecorderStatus(isRecording: true, startedAt: Date(timeIntervalSince1970: 1_723_000_000))
        let decoded = try JSONDecoder().decode(AACRecorderStatus.self, from: JSONEncoder().encode(value))
        XCTAssertTrue(decoded.isRecording)
        XCTAssertEqual(decoded.startedAt, value.startedAt)
    }

    func testAPIErrorRoundTrips() throws {
        let value = APIError("frequency not found")
        let decoded = try JSONDecoder().decode(APIError.self, from: JSONEncoder().encode(value))
        XCTAssertEqual(decoded.error, "frequency not found")
    }

    func testRequestTypesRoundTrip() throws {
        let tune = TuneFrequencyRequest(frequencyID: 7)
        XCTAssertEqual(try JSONDecoder().decode(TuneFrequencyRequest.self, from: JSONEncoder().encode(tune)).frequencyID, 7)

        let scan = StartCategoryScanRequest(categoryID: 2)
        XCTAssertEqual(try JSONDecoder().decode(StartCategoryScanRequest.self, from: JSONEncoder().encode(scan)).categoryID, 2)
    }

    func testEndpointsAreNamespacedUnderAPIv1() {
        for path in [APIEndpoint.categories, APIEndpoint.favorites, APIEndpoint.nowPlaying,
                     APIEndpoint.tune, APIEndpoint.startScan, APIEndpoint.stop, APIEndpoint.recorderStatus] {
            XCTAssertTrue(path.hasPrefix("/api/v1/"), "\(path) should live under /api/v1/")
        }
    }
}
