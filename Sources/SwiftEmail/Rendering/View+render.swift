extension View {

    public func render(options: RenderOptions = .init()) async -> RenderResult {
        var context = RenderContext()
        context.environmentValues.renderOptions = options
        context.environmentValues.globalStyle = context.globalStyle

        // Render!
        var result = await withTaskGroup(of: Void.self) { group in
            let result = render(options: options, taskGroup: &group, context: context)
            await group.waitForAll()
            return result
        }

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

    func render(options: RenderOptions, taskGroup: inout TaskGroup<Void>, context: RenderContext) -> RenderResult {
        EnvironmentValues.current = context.environmentValues
        if let primitiveView = self as? PrimitiveView {
            return primitiveView._render(options: options, taskGroup: &taskGroup, context: context)
        }
        return body.render(options: options, taskGroup: &taskGroup, context: context)
    }

    private func deferred(result: inout RenderResult, options: RenderOptions, context: RenderContext) async {
        await context.globalStyle.renderRootHTMLDeferred(
            result: &result,
            options: options,
            context: context
        )
    }
}
