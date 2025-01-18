import SnapshotTesting
import SwiftEmail
import SwiftEmailTesting
import Testing

@Suite
struct ImageTests {

  private let url = "https://static.qualtive.io/notifier/logo.png"

  @Test func renderHTML() throws {
    let root = Image(url)
    assertSnapshot(of: root, as: .html)
  }

  @Test func renderHTMLWithFixedSize() throws {
    let root = Image(url)
      .frame(width: 500, height: 200)
    assertSnapshot(of: root, as: .html)
  }

  @Test func renderHTMLWithBorder() throws {
    let root = Image(url)
      .border(Color.red)
    assertSnapshot(of: root, as: .html)
  }

  @Test func renderHTMLWithScaledToFill() throws {
    let root = Image(url)
      .frame(width: 500, height: 200)
      .scaledToFill()
    assertSnapshot(of: root, as: .html)
  }
}
