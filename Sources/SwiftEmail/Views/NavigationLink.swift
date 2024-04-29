public struct NavigationLink<Label>: View where Label: View {

    @Environment(\.buttonStyle) private var buttonStyle

    public enum Destination {
        case url(String)
    }

    public let destination: Destination
    public let label: Label

    public init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }

    public init(url: String, @ViewBuilder label: () -> Label) {
        self.destination = .url(url)
        self.label = label()
    }

    public var body: some View {
        if buttonStyle.content is LinkButtonStyle { // Optimiazation for default LinkButtonStyle
            UnsafeNode(tag: "a", attributes: [
                "href": destination,
            ]) {
                label
            }
        } else {
            UnsafeNode(tag: "a", attributes: [
                "href": destination,
                "style": "text-decoration:none", // Underline can be added through .underline() in the button style itself
            ]) {
                buttonStyle.makeBody(configuration: AnyButtonStyle.Configuration(
                    label: AnyButtonStyle.Configuration.Label(label)
                ))
            }
        }
    }
}

extension NavigationLink.Destination: UnsafeNodeAttributesValue {

    public func renderValue(environmentValues: EnvironmentValues) async -> String {
        switch self {
        case .url(let url):
            return url
        }
    }
}
