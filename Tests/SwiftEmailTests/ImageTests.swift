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

  @Test func renderHTMLWithSource() throws {
    let root = Email {
      Image(.logo)
    }
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

extension Image.Source {

  fileprivate static let logo = Image.Source(
    defaultURL: "https://static.qualtive.io/notifier/logo_2x.png?v2",
    alternatives: [
      "1x": "https://static.qualtive.io/notifier/logo.png?v2",
      "2x": "https://static.qualtive.io/notifier/logo_2x.png?v2",
      "3x": "https://static.qualtive.io/notifier/logo_3x.png?v2",
    ],
    darkURL: "https://static.qualtive.io/notifier/logo-dark_2x.png?v2",
    darkAlternatives: [
      "1x": "https://static.qualtive.io/notifier/logo-dark.png?v2",
      "2x": "https://static.qualtive.io/notifier/logo-dark_2x.png?v2",
      "3x": "https://static.qualtive.io/notifier/logo-dark_3x.png?v2",
    ]
  )
}
