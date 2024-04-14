extension View {

    public func renderHTML(options: HTMLRenderOptions = .init()) async -> String {
        let context = HTMLRenderContext()
        await prerender(options: options, context: context)

        let result = await renderHTML(options: options, context: context)
        switch options.format {
        case .compact:
            return result
        case .pretty:
            return result + "\n"
        }
    }

    func prerender(options: HTMLRenderOptions, context: HTMLRenderContext) async {
        if let primitiveView = self as? PrimitiveView {
            await primitiveView.prerenderRoot(options: options, context: context)
        } else {
            await body.prerender(options: options, context: context)
        }
    }

    func renderHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        EnvironmentValues.current = context.environmentValues
        if let primitiveView = self as? PrimitiveView {
            return await primitiveView.renderRootHTML(options: options, context: context)
        }
        return await body.renderHTML(options: options, context: context)
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
