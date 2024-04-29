extension View {

    public func unsafeGlobalStyle(
        _ key: String,
        _ value: String,
        selector: CSSSelector
    ) -> some View {
        unsafeGlobalStyle(key, { _ in value }, selector: selector)
    }

    public func unsafeGlobalStyle(
        _ key: String,
        _ value: any ShapeStyle,
        selector: CSSSelector
    ) -> some View {
        unsafeGlobalStyle(key, { await value.renderCSSValue(environmentValues: $0) }, selector: selector)
    }

    private func unsafeGlobalStyle(
        _ key: String,
        _ value: @escaping (EnvironmentValues) async -> String,
        selector: CSSSelector
    ) -> some View {
        GlobalStyleOverride(key: key, value: value, selector: selector, content: self)
    }
}

private struct GlobalStyleOverride<Content: View>: View {

    let key: String
    let value: (EnvironmentValues) async -> String
    let selector: CSSSelector
    let content: Content
}

extension GlobalStyleOverride: PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        await context.globalStyle.insert(
            key: key,
            value: await value(context.environmentValues),
            selector: selector
        )
        return await content.renderHTML(options: options, context: context)
    }
}
