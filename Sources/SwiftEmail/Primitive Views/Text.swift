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
        let needsRenderFont = context.renderedFont != font
        context.renderedFont = font

        let backgroundStyle = context.environmentValues.backgroundStyle
        let needsRenderBackgroundStyle = context.renderedBackgroundStyle != backgroundStyle
        context.renderedBackgroundStyle = backgroundStyle

        let borderStyle = context.environmentValues.borderStyle
        let needsRenderBorderStyle = context.renderedBorderStyle != borderStyle
        context.renderedBorderStyle = borderStyle

        let className = context.environmentValues.className
        let needsRenderClassName = context.renderedClassName != className
        context.renderedClassName = className

        var style = ""
        if needsRenderBackgroundStyle {
            if !style.isEmpty { style += ";" }
            style += "background:" + (await backgroundStyle.renderCSSValue(environmentValues: context.environmentValues))
        }
        if needsRenderBorderStyle {
            if !style.isEmpty { style += ";" }
            style += "border:" + (await borderStyle.renderCSSValue(environmentValues: context.environmentValues))
        }

        // Rendering font may require inserts of multiple nodes for accessbility (bold and italic)
        if needsRenderFont {
            if !style.isEmpty { style += ";" }
            return await body(
                style: style,
                className: needsRenderClassName ? className : nil,
                options: options,
                context: context
            )
            .renderHTML(options: options, context: context)
        }

        // Wrap in span-node if any styling or class name needs to be applied
        if !style.isEmpty || needsRenderClassName {
            var attributes: UnsafeNode<PlainText>.Attributes = [
                "style": style
            ]
            if needsRenderClassName, let className {
                attributes.values["class"] = className.renderCSS(options: options)
            }
            return await UnsafeNode(tag: "span", attributes: attributes) {
                PlainText(value)
            }
            .renderHTML(options: options, context: context)
        }

        // No styling, just return plain text
        return await PlainText(value)
            .renderHTML(options: options, context: context)
    }

    @ViewBuilder private func body(
        style: String,
        className: ClassName?,
        options: HTMLRenderOptions,
        context: HTMLRenderContext
    ) async -> some View {
        let font = context.environmentValues.font
        let size: String = "\(font.size)px"
        let weight: String = await font.weight.renderCSSValue(environmentValues: context.environmentValues)
        let name: String = font.name
        let isBold = font.weight.isBold
        let isItalic = font.isItalic
        var style = style + "font-size:\(size);font-weight:\(weight);font-family:\(name)"
        if isItalic {
            let _ = {
                style += ";font-style:italic"
            }()
        }
        var attributes: UnsafeNode<PlainText>.Attributes = [
            "style": style
        ]
        if let className {
            let _ = {
                attributes.values["class"] = className.renderCSS(options: options)
            }()
        }
        if isBold && isItalic {
            UnsafeNode(tag: "i") {
                UnsafeNode(tag: "b", attributes: attributes) {
                    PlainText(value)
                }
            }
        } else {
            UnsafeNode(tag: isBold ? "b" : isItalic ? "i" : "span", attributes: attributes) {
                PlainText(value)
            }
        }
    }
}
