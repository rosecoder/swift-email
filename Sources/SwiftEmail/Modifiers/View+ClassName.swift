extension View {

    public func unsafeClass(_ className: ClassName) -> some View {
        ClassOverride(className: className, content: self)
    }
}

private struct ClassOverride<Content: View>: View {

    let className: ClassName
    let content: Content
}

extension ClassOverride: PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        await UnsafeNode(tag: "span", attributes: [
            "class": className.renderCSS(options: options),
        ]) {
            content
        }.renderRootHTML(options: options, context: context)
    }
}
