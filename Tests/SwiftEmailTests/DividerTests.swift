import XCTest
import SwiftEmail

final class DividerTests: XCTestCase {

    func testRenderHTML() async throws {
        let html = await Divider().renderHTML()
        XCTAssertEqual(html, "<hr/>")
    }
}
