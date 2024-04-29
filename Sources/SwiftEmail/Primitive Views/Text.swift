public struct Text: View {

    let value: String

    public init(_ value: String) {
        self.value = value
    }

    public var body: some View { noBody }
}

extension Text: PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        var context = context
        let font = context.environmentValues.font
        let backgroundStyle = context.environmentValues.backgroundStyle

        let needsRenderFont = context.renderedFont != font
        let needsRenderBackgroundStyle = context.renderedBackgroundStyle != backgroundStyle

        if !needsRenderFont {
            if !needsRenderBackgroundStyle {
                return await PlainText(value)
                    .renderHTML(options: options, context: context)
            }
            context.renderedBackgroundStyle = backgroundStyle
            return await PlainText(value)
                .unsafeStyle("background", backgroundStyle as CSSValue)
                .renderHTML(options: options, context: context)
        }

        context.renderedFont = font
        context.renderedBackgroundStyle = backgroundStyle
        return await body(needsRenderBackgroundStyle: needsRenderBackgroundStyle, options: options, context: context)
            .renderHTML(options: options, context: context)
    }

    @ViewBuilder private func body(needsRenderBackgroundStyle: Bool, options: HTMLRenderOptions, context: HTMLRenderContext) async -> some View {
        let font = context.environmentValues.font
        let backgroundStyle = context.environmentValues.backgroundStyle
        let size: String = "\(font.size)px"
        let weight: String = await font.weight.renderCSSValue(environmentValues: context.environmentValues)
        let name: String = font.name
        let isBold = font.weight.isBold
        let isItalic = font.isItalic
        var style = "font-size:\(size);font-weight:\(weight);font-family:\(name)"
        if isItalic {
            let _ = {
                style += ";font-style:italic"
            }()
        }
        if needsRenderBackgroundStyle {
            let _ = await {
                style += ";background:" + (await backgroundStyle.renderCSSValue(environmentValues: context.environmentValues))
            }()
        }
        if isBold && isItalic {
            UnsafeNode(tag: "i") {
                UnsafeNode(tag: "b", attributes: [
                    "style": style
                ]) {
                    PlainText(value)
                }
            }
        } else {
            UnsafeNode(tag: isBold ? "b" : isItalic ? "i" : "span", attributes: [
                "style": style
            ]) {
                PlainText(value)
            }
        }
    }
}
