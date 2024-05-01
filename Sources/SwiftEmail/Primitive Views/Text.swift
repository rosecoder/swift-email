public struct Text: View {

    let value: String

    public init(_ value: String) {
        self.value = value
    }

    public var body: some View { noBody }
}

extension Text: PrimitiveView {

    func renderRootHTML(options: RenderOptions, context: RenderContext) async -> String {
        var context = context
        
        let font = context.environmentValues.font
        let needsRenderFont = context.renderedFont != font
        context.renderedFont = font

        let backgroundStyle = context.environmentValues.backgroundStyle
        let needsRenderBackgroundStyle = context.renderedBackgroundStyle != backgroundStyle
        context.renderedBackgroundStyle = backgroundStyle

        let foregroundStyle = context.environmentValues.foregroundStyle
        let needsRenderForegroundStyle = context.renderedForegroundStyle != foregroundStyle
        context.renderedForegroundStyle = foregroundStyle

        let cornerRadius = context.environmentValues.cornerRadius
        let needsRenderCornerRadius = context.renderedCornerRadius != cornerRadius
        context.renderedCornerRadius = cornerRadius

        let borderStyle = context.environmentValues.borderStyle
        let needsRenderBorderStyle = context.renderedBorderStyle != borderStyle
        context.renderedBorderStyle = borderStyle

        let classNames = context.environmentValues.classNames.subtracting(context.renderedClassName)
        classNames.forEach { context.renderedClassName.insert($0) }

        let underline = context.environmentValues.underline
        let needsRenderUnderline = context.renderedUnderline != underline
        context.renderedUnderline = underline

        var style = ""
        if needsRenderBackgroundStyle {
            if !style.isEmpty { style += ";" }
            style += "background:" + (await backgroundStyle.renderCSSValue(environmentValues: context.environmentValues))
        }
        if needsRenderForegroundStyle {
            if !style.isEmpty { style += ";" }
            style += "color:" + (await foregroundStyle.renderCSSValue(environmentValues: context.environmentValues))
        }
        if needsRenderCornerRadius {
            if !style.isEmpty { style += ";" }
            style += "border-radius:" + String(Int(cornerRadius)) + "px"
        }
        if needsRenderBorderStyle {
            if !style.isEmpty { style += ";" }
            style += "border:" + (await borderStyle.renderCSSValue(environmentValues: context.environmentValues))
        }
        if needsRenderUnderline {
            if !style.isEmpty { style += ";" }
            style += "text-decoration:" + (underline ? "underline" : "none")
        }

        // Rendering font may require inserts of multiple nodes for accessbility (bold and italic)
        if needsRenderFont {
            if !style.isEmpty { style += ";" }
            return await body(
                style: style,
                classNames: classNames,
                options: options,
                context: context
            )
            .renderHTML(options: options, context: context)
        }

        // Wrap in span-node if any styling or class name needs to be applied
        if !style.isEmpty || !classNames.isEmpty {
            var attributes: UnsafeNode<PlainText>.Attributes = [
                "style": style
            ]
            if !classNames.isEmpty {
                attributes.values["class"] = classNames.renderValue(options: options)
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
        classNames: ClassNames,
        options: RenderOptions,
        context: RenderContext
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
        if !classNames.isEmpty {
            let _ = {
                attributes.values["class"] = classNames.renderValue(options: options)
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
