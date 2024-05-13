import XCTest
import SnapshotTesting
import SwiftEmail
import SwiftEmailTesting

final class DividerTests: XCTestCase {

    func testRender() async throws {
        let render = await Divider().render()
        XCTAssertEqual(render.html, "<hr style=\"border:0;border-top:1px solid #D6D3D4\"/>")
        XCTAssertEqual(render.text, "\n")
    }

    func testRenderWithColor() {
        let email = Email {
            Divider()
                .overlay(Color.text)
        }
        assertSnapshot(of: email, as: .html)
        assertSnapshot(of: email, as: .text)
    }
}
