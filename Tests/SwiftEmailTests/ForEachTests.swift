import XCTest
import SnapshotTesting
import SwiftEmail
import SwiftEmailTesting

final class ForEachTests: XCTestCase {

    func testRenderHTML() throws {
        let array: [String] = [
            "A",
            "B",
            "C",
            "D",
        ]
        let email = ForEach(array) { element in
            Text(element)
        }
        assertSnapshot(of: email, as: .html)
    }
}
