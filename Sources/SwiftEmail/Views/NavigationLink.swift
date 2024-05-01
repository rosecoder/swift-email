public struct NavigationLink<Label>: View where Label: View {

    @Environment(\.buttonStyle) private var buttonStyle
    @Environment(\.foregroundStyle) private var foregroundStyle
    @Environment(\.globalStyle) private var globalStyle

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
        get async {
            let styles = await {
                var styles = Styles()
                if !(buttonStyle.content is LinkButtonStyle) {
                    styles["text-decoration"] = "none" // Underline can be added through .underline() in the button style itself
                }
                styles["color"] = foregroundStyle
                if (foregroundStyle.content as? Color)?.hasAlternative != false {
                    await globalStyle.insert(key: "color", value: foregroundStyle, selector: .element("a", colorScheme: .dark))
                }
                return styles
            }()
            UnsafeNode(tag: "a", attributes: [
                "href": destination,
                "style": styles
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
