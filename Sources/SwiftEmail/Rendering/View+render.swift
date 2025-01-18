extension View {

    public func render(options: RenderOptions = .init()) -> RenderResult {
        var context = RenderContext()
        context.environmentValues.renderOptions = options
        context.environmentValues.globalStyle = context.globalStyle

        // Render!
        var result = render(options: options, context: context)

        // Adjust output for deferred components (like global styles)
        deferred(result: &result, options: options, context: context)

        // Suffix
        switch options.format {
        case .compact:
            break
        case .pretty:
            result.html += "\n"
            result.text += "\n"
        }
        return result
    }

    func render(options: RenderOptions, context: RenderContext) -> RenderResult {
        EnvironmentValues.$current.withValue(context.environmentValues) {
            if let primitiveView = self as? PrimitiveView {
                return primitiveView._render(options: options, context: context)
            }
            return body.render(options: options, context: context)
        }
    }

    private func deferred(
        result: inout RenderResult, options: RenderOptions, context: RenderContext
    ) {
        context.globalStyle.renderRootHTMLDeferred(
            result: &result,
            options: options,
            context: context
        )
    }
}
