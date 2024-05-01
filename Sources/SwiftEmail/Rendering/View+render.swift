extension View {

    public func render(options: RenderOptions = .init()) async -> RenderResult {
        var context = RenderContext()
        context.environmentValues.renderOptions = options
        context.environmentValues.globalStyle = context.globalStyle

        // Render!
        var result = await render(options: options, context: context)

        // Adjust output for deferred components (like global styles)
        await deferred(result: &result, options: options, context: context)

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

    func render(options: RenderOptions, context: RenderContext) async -> RenderResult {
        EnvironmentValues.current = context.environmentValues
        if let primitiveView = self as? PrimitiveView {
            return await primitiveView._render(options: options, context: context)
        }
        return await body.render(options: options, context: context)
    }

    private func deferred(result: inout RenderResult, options: RenderOptions, context: RenderContext) async {
        await context.globalStyle.renderRootHTMLDeferred(
            result: &result,
            options: options,
            context: context
        )
    }
}
