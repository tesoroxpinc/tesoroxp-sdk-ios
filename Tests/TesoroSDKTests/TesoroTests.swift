import XCTest
@testable import TesoroSDK

final class TesoroTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Tesoro.reset()
    }

    override func tearDown() {
        Tesoro.reset()
        super.tearDown()
    }

    // MARK: - Configuration Tests

    func testIsNotConfiguredInitially() {
        XCTAssertFalse(Tesoro.isConfigured)
        XCTAssertNil(Tesoro.currentMode)
    }

    func testConfigureWithProductionMode() {
        Tesoro.configure(mode: .production, playerId: "player_123")

        XCTAssertTrue(Tesoro.isConfigured)
        XCTAssertEqual(Tesoro.currentMode, .production)
    }

    func testConfigureWithTestMode() {
        Tesoro.configure(mode: .test, playerId: "player_456")

        XCTAssertTrue(Tesoro.isConfigured)
        XCTAssertEqual(Tesoro.currentMode, .test)
    }

    func testConfigureWithMetadata() {
        let metadata = ["campaign": "summer2024", "source": "app"]
        Tesoro.configure(mode: .test, playerId: "player_789", metadata: metadata)

        XCTAssertTrue(Tesoro.isConfigured)
    }

    func testResetClearsConfiguration() {
        Tesoro.configure(mode: .production, playerId: "player_123")
        XCTAssertTrue(Tesoro.isConfigured)

        Tesoro.reset()
        XCTAssertFalse(Tesoro.isConfigured)
        XCTAssertNil(Tesoro.currentMode)
    }

    // MARK: - Mode Tests

    func testProductionModeBaseURL() {
        let url = TesoroMode.production.baseURL
        XCTAssertEqual(url.absoluteString, "https://valuewall.tesoroxp.com")
    }

    func testTestModeBaseURL() {
        let url = TesoroMode.test.baseURL
        XCTAssertEqual(url.absoluteString, "https://test.valuewall.tesoroxp.com")
    }

    // MARK: - Options Tests

    func testDefaultOptions() {
        let options = TesoroOptions()

        XCTAssertNil(options.closeButtonColor)
    }

    func testCustomCloseButtonColor() {
        let color = UIColor.blue
        let options = TesoroOptions(closeButtonColor: color)

        XCTAssertEqual(options.closeButtonColor, color)
    }
}
