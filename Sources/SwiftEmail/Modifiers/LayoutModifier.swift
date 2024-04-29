struct LayoutProperties {

    var padding: EdgeInsets?
    var minWidth: Float?
    var idealWidth: Float?
    var maxWidth: Float?
    var minHeight: Float?
    var idealHeight: Float?
    var maxHeight: Float?
    var alignment: Alignment?

    init(
        padding: EdgeInsets? = nil,
        minWidth: Float? = nil,
        idealWidth: Float? = nil,
        maxWidth: Float? = nil,
        minHeight: Float? = nil,
        idealHeight: Float? = nil,
        maxHeight: Float? = nil,
        alignment: Alignment? = nil
    ) {
        self.padding = padding
        self.minWidth = minWidth
        self.idealWidth = idealWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.idealHeight = idealHeight
        self.maxHeight = maxHeight
        self.alignment = alignment
    }
}

struct LayoutModifier: ViewModifier {

    let tag: String
    let properties: LayoutProperties

    func body(content: Content) -> some View {
        LayoutView(properties: properties) { context in
            context.topTR
            UnsafeNode(tag: "tr", attributes: context.aligmentAttributes ?? [:]) {
                AnyView(body(content: content, context: context))
            }
            context.bottomTR
        }
        .tag(tag)
    }

    @ViewBuilder private func body(content: Content, context: LayoutBodyContext) -> some View {
        context.leadingTD
        UnsafeNode(tag: "td") {
            content
        }
        context.trailingTD
    }
}

struct LayoutBodyContext {

    let topTR: AnyView
    let bottomTR: AnyView
    let aligmentAttributes: UnsafeNode<AnyView>.Attributes?
    let leadingTD: AnyView
    let trailingTD: AnyView
}

struct LayoutView<Content: View>: View {

    let properties: LayoutProperties
    let content: (LayoutBodyContext) async -> Content

    init(
        properties: LayoutProperties,
        @ViewBuilder content: @escaping (LayoutBodyContext) async -> Content
    ) {
        self.properties = properties
        self.content = content
    }

    func body(
        className: ClassName?,
        backgroundStyle: AnyShapeStyle?,
        borderStyle: AnyShapeStyle?,
        options: HTMLRenderOptions
    ) async -> some View {
        await UnsafeNode(tag: "table", attributes: attributes(
            className: className,
            backgroundStyle: backgroundStyle,
            borderStyle: borderStyle,
            options: options
        )) {
            await AnyView {
                await content(bodyContext)
            }
        }
    }

    private func attributes(
        className: ClassName?,
        backgroundStyle: AnyShapeStyle?,
        borderStyle: AnyShapeStyle?,
        options: HTMLRenderOptions
    ) -> UnsafeNode<AnyView>.Attributes {
        var attributes: UnsafeNode<AnyView>.Attributes = [
            "cellspacing": "0",
            "cellpadding": "0",
            "border": "0"
        ]
        var styles = Styles()
        if let minWidth = properties.minWidth {
            styles["min-width"] = minWidth
        }
        if let maxWidth = properties.maxWidth {
            attributes.values["width"] = "100%"
            if maxWidth != .infinity {
                styles["max-width"] = maxWidth
            }
        }
        if let idealWidth = properties.idealWidth {
            attributes.values["width"] = String(Int(idealWidth))
        }
        if let minHeight = properties.minHeight {
            styles["min-height"] = minHeight
        }
        if let maxHeight = properties.maxHeight {
            attributes.values["height"] = "100%"
            if maxHeight != .infinity {
                styles["max-height"] = maxHeight
            }
        }
        if let idealHeight = properties.idealHeight {
            attributes.values["height"] = String(Int(idealHeight))
        }
        if let backgroundStyle {
            styles["background"] = backgroundStyle
        }
        if let borderStyle {
            styles["border"] = borderStyle
        }
        if !styles.isEmpty {
            attributes.values["style"] = styles
        }
        if let className {
            attributes.values["class"] = className.renderCSS(options: options)
        }
        return attributes
    }

    private var bodyContext: LayoutBodyContext {
        .init(
            topTR: verticalTR(height: properties.padding?.top),
            bottomTR: verticalTR(height: properties.padding?.bottom),
            aligmentAttributes: properties.alignment.flatMap {
                [
                    "align": $0.horizontal.tdAlign,
                    "valign": $0.vertical.tdAlign,
                ]
            },
            leadingTD: horizontalTD(width: properties.padding?.leading),
            trailingTD: horizontalTD(width: properties.padding?.trailing)
        )
    }

    private func verticalTR(height: Float?) -> AnyView {
        guard let height, height != 0 else {
            return AnyView(EmptyView())
        }
        return AnyView(UnsafeNode(tag: "tr") {
            UnsafeNode(tag: "td", attributes: ["height": String(Int(height))]) {
                EmptyView()
            }
        })
    }

    private func horizontalTD(width: Float?) -> AnyView {
        guard let width, width != 0 else {
            return AnyView(EmptyView())
        }
        return AnyView(UnsafeNode(tag: "td", attributes: ["width": String(Int(width))]) {
            EmptyView()
        })
    }
}

extension LayoutView: PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        var context = context
        
        let backgroundStyle = context.renderedBackgroundStyle == context.environmentValues.backgroundStyle ? nil : context.environmentValues.backgroundStyle
        context.renderedBackgroundStyle = context.environmentValues.backgroundStyle

        let borderStyle = context.renderedBorderStyle == context.environmentValues.borderStyle ? nil : context.environmentValues.borderStyle
        context.renderedBorderStyle = context.environmentValues.borderStyle

        let className = context.renderedClassName == context.environmentValues.className ? nil : context.environmentValues.className
        context.renderedClassName = context.environmentValues.className

        return await body(
            className: className,
            backgroundStyle: backgroundStyle,
            borderStyle: borderStyle,
            options: options
        ).renderHTML(options: options, context: context)
    }
}
