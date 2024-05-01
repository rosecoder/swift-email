import XCTest
import SwiftEmail

final class DividerTests: XCTestCase {

    func testRenderHTML() async throws {
        let render = await Divider().render()
        XCTAssertEqual(render.html, "<hr/>")
        XCTAssertEqual(render.text, "")
    }
}
