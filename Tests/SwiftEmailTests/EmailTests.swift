import Testing
import SnapshotTesting
import SwiftEmail
import SwiftEmailTesting

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

@Suite
struct EmailTests {

    @Test func render() {
        let email = Email {
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("This is a text.")

                        Text("Hover me")
                            .background(Color.red)
                            .fontWeight(.bold)
                            .font(.system.italic())
                            .foregroundStyle(Color.blue, when: .hover)
                            .foregroundStyle(Color.black)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .cornerRadius(50, when: .hover)
                    }
                    Text("This is a text on another row.")
                    Divider()
                    Image(.logo)
                        .frame(height: 28)
                }
                .frame(maxWidth: 700)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }

        assertSnapshot(of: email, as: .html)
        assertSnapshot(of: email, as: .text)
    }
}
