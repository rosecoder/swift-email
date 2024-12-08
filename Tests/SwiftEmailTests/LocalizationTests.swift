import Foundation
import Testing
import SnapshotTesting
@testable import SwiftEmail

@Suite
struct LocalizationTests {

    @Test func translateStaticKey() {
        let english = LocalizedStringsService.shared.translated(
            key: "testing",
            bundle: .module,
            locale: Locale(identifier: "en_US")
        )
        #expect(english == "Testing")

        let swedish = LocalizedStringsService.shared.translated(
            key: "testing",
            bundle: .module,
            locale: Locale(identifier: "sv_SE")
        )
        #expect(swedish == "Testar")
    }

    @Test func translateFormattedKey() {
        let interpolationValue = "things!"

        let english = LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue)",
            bundle: .module,
            locale: Locale(identifier: "en_US")
        )
        #expect(english == "Testing things!")

        let swedish = LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue)",
            bundle: .module,
            locale: Locale(identifier: "sv_SE")
        )
        #expect(swedish == "Testar things!")
    }

    @Test func translateFormattedKeyFormatter() {
        let interpolationValue: NSNumber = 100
        let numberFormatter = NumberFormatter()

        let english = LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue, formatter: numberFormatter)",
            bundle: .module,
            locale: Locale(identifier: "en_US")
        )
        #expect(english == "Testing 100")

        let swedish = LocalizedStringsService.shared.translated(
            key: "testing \(interpolationValue, formatter: numberFormatter)",
            bundle: .module,
            locale: Locale(identifier: "sv_SE")
        )
        #expect(swedish == "Testar 100")
    }

    @Test func textStaticKey() {
        do {
            let render = Text("testing", bundle: .module).environment(\.locale, Locale(identifier: "en")).render()
            #expect(render.html == "Testing")
        }
        do {
            let render = Text("testing", bundle: .module).environment(\.locale, Locale(identifier: "sv")).render()
                #expect(render.html == "Testar")
        }
    }

    @Test func textFormattedKey() {
        do {
            let render = Text("testing \("hello")", bundle: .module).environment(\.locale, Locale(identifier: "en")).render()
            #expect(render.html == "Testing hello")
        }
        do {
            let render = Text("testing \("hello")", bundle: .module).environment(\.locale, Locale(identifier: "sv")).render()
            #expect(render.html == "Testar hello")
        }
    }
}
