extension View {

    public func renderHTML(options: RenderOptions = .init()) async -> String {
        var context = RenderContext()
        context.environmentValues.renderOptions = options
        context.environmentValues.globalStyle = context.globalStyle

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

    func renderHTML(options: RenderOptions, context: RenderContext) async -> String {
        EnvironmentValues.current = context.environmentValues
        if let primitiveView = self as? PrimitiveView {
            return await primitiveView.renderRootHTML(options: options, context: context)
        }
        return await body.renderHTML(options: options, context: context)
    }

    private func deferred(result: inout String, options: RenderOptions, context: RenderContext) async {
        await context.globalStyle.renderRootHTMLDeferred(
            result: &result,
            options: options,
            context: context
        )
    }
}
