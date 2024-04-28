import XCTest
import SnapshotTesting
import SwiftEmail
import SwiftEmailTesting

final class NavigationLinkTests: XCTestCase {

    func testNavigationLink() {
        let view = NavigationLink(url: "https://qualtive.io/") {
            Text("Link")
        }
        assertSnapshot(of: view, as: .html)
    }
}
