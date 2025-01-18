import SnapshotTesting
import SwiftEmail
import SwiftEmailTesting
import Testing

@Suite
struct ForEachTests {

  @Test func testRenderHTML() throws {
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
