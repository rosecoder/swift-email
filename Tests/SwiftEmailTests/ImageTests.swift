import XCTest
import SnapshotTesting
import SwiftEmail
import SwiftEmailTesting

final class ImageTests: XCTestCase {

    private let url = "https://static.qualtive.io/notifier/logo.png"

    func testRenderHTML() throws {
        let root = Image(url)
        assertSnapshot(of: root, as: .html)
    }

    func testRenderHTMLWithFixedSize() throws {
        let root = Image(url)
            .frame(width: 500, height: 200)
        assertSnapshot(of: root, as: .html)
    }

    func testRenderHTMLWithBorder() throws {
        let root = Image(url)
            .border(Color.red)
        assertSnapshot(of: root, as: .html)
    }
}
