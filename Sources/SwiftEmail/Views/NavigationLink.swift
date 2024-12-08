public struct NavigationLink<Label>: View where Label: View {

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

    public var body: some View { noBody }
}

extension NavigationLink.Destination: UnsafeNodeAttributesValue {

    public func renderValue(environmentValues: EnvironmentValues) -> String {
        switch self {
        case .url(let url):
            return url
        }
    }
}

extension NavigationLink: PrimitiveView {

    func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
        var styles = Styles()
        if !(context.environmentValues.buttonStyle.content is LinkButtonStyle) {
            styles["text-decoration"] = "none" // Underline can be added through .underline() in the button style itself
        }
        styles["color"] = context.environmentValues.foregroundStyle

        context.globalStyle.insert(
            key: "color",
            value: context.environmentValues.foregroundStyle,
            selector: .element("a", colorScheme: .dark)
        )

        return UnsafeNode(tag: "a", attributes: [
            "href": destination,
            "style": styles
        ]) {
            context.environmentValues.buttonStyle.makeBody(configuration: AnyButtonStyle.Configuration(
                label: AnyButtonStyle.Configuration.Label(label)
            ))
        }
        .render(options: options, context: context)
    }
}
