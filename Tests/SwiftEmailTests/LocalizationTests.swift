import XCTest
import SnapshotTesting
@testable import SwiftEmail

final class LocalizationTests: XCTestCase {

    func testTranslateStaticKey() async {
        let english = await LocalizedStringsService.shared.translated(
            key: "testing",
            bundle: .module,
            locale: Locale(identifier: "en_US")
        )
        XCTAssertEqual(english, "Testing")

        let swedish = await LocalizedStringsService.shared.translated(
            key: "testing",
            bundle: .module,
            locale: Locale(identifier: "sv_SE")
        )
        XCTAssertEqual(swedish, "Testar")
    }

    func testTranslateFormattedKey() async {
        let interpolationValue = "things!"

        let english = await LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue)",
            bundle: .module,
            locale: Locale(identifier: "en_US")
        )
        XCTAssertEqual(english, "Testing things!")

        let swedish = await LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue)",
            bundle: .module,
            locale: Locale(identifier: "sv_SE")
        )
        XCTAssertEqual(swedish, "Testar things!")
    }

    func testTranslateFormattedKeyFormatter() async {
        let interpolationValue: NSNumber = 100
        let numberFormatter = NumberFormatter()

        let english = await LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue, formatter: numberFormatter)",
            bundle: .module,
            locale: Locale(identifier: "en_US")
        )
        XCTAssertEqual(english, "Testing 100")

        let swedish = await LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue, formatter: numberFormatter)",
            bundle: .module,
            locale: Locale(identifier: "sv_SE")
        )
        XCTAssertEqual(swedish, "Testar 100")
    }
}
