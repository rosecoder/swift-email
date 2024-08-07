import XCTest
import SnapshotTesting
@testable import SwiftEmail

final class LocalizationTests: XCTestCase {

    func testTranslateStaticKey() async {
        let english = LocalizedStringsService.shared.translated(
            key: "testing",
            bundle: .module,
            locale: Locale(identifier: "en_US")
        )
        XCTAssertEqual(english, "Testing")

        let swedish = LocalizedStringsService.shared.translated(
            key: "testing",
            bundle: .module,
            locale: Locale(identifier: "sv_SE")
        )
        XCTAssertEqual(swedish, "Testar")
    }

    func testTranslateFormattedKey() async {
        let interpolationValue = "things!"

        let english = LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue)",
            bundle: .module,
            locale: Locale(identifier: "en_US")
        )
        XCTAssertEqual(english, "Testing things!")

        let swedish = LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue)",
            bundle: .module,
            locale: Locale(identifier: "sv_SE")
        )
        XCTAssertEqual(swedish, "Testar things!")
    }

    func testTranslateFormattedKeyFormatter() async {
        let interpolationValue: NSNumber = 100
        let numberFormatter = NumberFormatter()

        let english = LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue, formatter: numberFormatter)",
            bundle: .module,
            locale: Locale(identifier: "en_US")
        )
        XCTAssertEqual(english, "Testing 100")

        let swedish = LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue, formatter: numberFormatter)",
            bundle: .module,
            locale: Locale(identifier: "sv_SE")
        )
        XCTAssertEqual(swedish, "Testar 100")
    }

    func testTextStaticKey() async {
        do {
            let render = await Text("testing", bundle: .module).environment(\.locale, Locale(identifier: "en")).render()
            XCTAssertEqual(render.html, "Testing")
        }
        do {
            let render = await Text("testing", bundle: .module).environment(\.locale, Locale(identifier: "sv")).render()
            XCTAssertEqual(render.html, "Testar")
        }
    }

    func testTextFormattedKey() async {
        do {
            let render = await Text("testing \("hello")", bundle: .module).environment(\.locale, Locale(identifier: "en")).render()
            XCTAssertEqual(render.html, "Testing hello")
        }
        do {
            let render = await Text("testing \("hello")", bundle: .module).environment(\.locale, Locale(identifier: "sv")).render()
            XCTAssertEqual(render.html, "Testar hello")
        }
    }
}
