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
            .border(Color.text, width: 1)
            .border(Color.gray, width: 1, when: .active)
            .background(Color.text, when: .hover)
            .background(Color.gray, when: .active)
            .foregroundStyle(Color.background, when: .hover)
            .foregroundStyle(Color.background, when: .active)
            .cornerRadius(6)
        }
    }
}
