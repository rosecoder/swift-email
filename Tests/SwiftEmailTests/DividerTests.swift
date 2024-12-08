import Testing
import SnapshotTesting
import SwiftEmail
import SwiftEmailTesting

@Suite
struct DividerTests {

    @Test func render() {
        let render = Divider().render()
        #expect(render.html == "<hr style=\"border:0;border-top:1px solid #D6D3D4\"/>")
        #expect(render.text == "\n")
    }

    @Test func renderWithColor() {
        let email = Email {
            Divider()
                .overlay(Color.text)
        }
        assertSnapshot(of: email, as: .html)
        assertSnapshot(of: email, as: .text)
    }
}
