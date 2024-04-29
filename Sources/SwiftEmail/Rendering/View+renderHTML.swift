extension View {

    public func renderHTML(options: HTMLRenderOptions = .init()) async -> String {
        let context = HTMLRenderContext()

        // Render!
        var result = await renderHTML(options: options, context: context)

        // Adjust output for deferred components (like global styles)
        await deferred(result: &result, options: options, context: context)

        // Suffix
        switch options.format {
        case .compact:
            return result
        case .pretty:
            return result + "\n"
        }
    }

    func renderHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        EnvironmentValues.current = context.environmentValues
        if let primitiveView = self as? PrimitiveView {
            return await primitiveView.renderRootHTML(options: options, context: context)
        }
        return await body.renderHTML(options: options, context: context)
    }

    private func deferred(result: inout String, options: HTMLRenderOptions, context: HTMLRenderContext) async {
        await context.globalStyle.renderRootHTMLDeferred(
            result: &result,
            options: options,
            context: context
        )
    }
}

public struct HTMLRenderOptions {

    public enum Format {
        case compact
        case pretty
    }

    public var format: Format
    public var indent: String

    public init(
        format: Format = .compact,
        indent: String = "  "
    ) {
        self.format = format
        self.indent = indent
    }
}

struct HTMLRenderContext {

    let globalStyle = GlobalStyle()
    var indentationLevel: UInt16 = 0
    var environmentValues: EnvironmentValues = .init()
    var renderedFont: Font = EnvironmentValues.default.font
    var renderedBackgroundStyle: AnyShapeStyle = EnvironmentValues.default.backgroundStyle
    var renderedForegroundStyle: AnyShapeStyle = EnvironmentValues.default.foregroundStyle
    var renderedTag: AnyHashable?

    func indentation(options: HTMLRenderOptions) -> String {
        switch options.format {
        case .compact:
            ""
        case .pretty:
            String(repeating: options.indent, count: Int(indentationLevel))
        }
    }
}
