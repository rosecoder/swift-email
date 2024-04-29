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

    func testNavigationLinkWithButtonStyle() {
        let view = Email {
            NavigationLink(url: "https://qualtive.io/") {
                Text("Link")
            }
        }
            .buttonStyle(CustomButtonStyle())
        assertSnapshot(of: view, as: .html)
    }

    private struct CustomButtonStyle: ButtonStyle {

        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.label
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
            .border(Color.black, width: 1)
            .border(Color.green, width: 1, when: .hover)
            .underline(when: .hover)
            .cornerRadius(6)
        }
    }
}
