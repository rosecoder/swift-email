struct Body<Content: View>: View {

    @Environment(\.font) private var font
    @Environment(\.backgroundStyle) private var backgroundStyle
    @Environment(\.foregroundStyle) private var foregroundStyle

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        UnsafeNode(tag: "body", attributes: [
            "style": Styles(properties: [
                "font-family": font,
                "font-weight": font.weight,
                "font-size": font.size,
                "background": backgroundStyle,
                "color": foregroundStyle,
                "margin": "0",
            ])
        ]) {
            content
        }
    }
}

extension Body: PrimitiveView {

    func _render(options: RenderOptions, context: RenderContext) async -> RenderResult {
        await context.globalStyle.insert(
            key: "color",
            value: context.environmentValues.foregroundStyle,
            selector: .element("body", colorScheme: .dark)
        )
        await context.globalStyle.insert(
            key: "background",
            value: context.environmentValues.backgroundStyle,
            selector: .element("body", colorScheme: .dark)
        )

        var context = context
        context.renderedFont = context.environmentValues.font
        context.renderedBackgroundStyle = context.environmentValues.backgroundStyle
        context.renderedForegroundStyle = context.environmentValues.foregroundStyle
        return await body.render(options: options, context: context)
    }
}
