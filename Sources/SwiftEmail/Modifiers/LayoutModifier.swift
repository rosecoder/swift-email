struct LayoutProperties {

    var padding: EdgeInsets?
    var minWidth: Float?
    var idealWidth: Float?
    var maxWidth: Float?
    var minHeight: Float?
    var idealHeight: Float?
    var maxHeight: Float?
    var alignment: Alignment?
    var textSeparator: String

    init(
        padding: EdgeInsets? = nil,
        minWidth: Float? = nil,
        idealWidth: Float? = nil,
        maxWidth: Float? = nil,
        minHeight: Float? = nil,
        idealHeight: Float? = nil,
        maxHeight: Float? = nil,
        alignment: Alignment? = nil,
        textSeparator: String
    ) {
        self.padding = padding
        self.minWidth = minWidth
        self.idealWidth = idealWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.idealHeight = idealHeight
        self.maxHeight = maxHeight
        self.alignment = alignment
        self.textSeparator = textSeparator
    }
}

protocol LayoutableView {

    var layoutProperties: LayoutProperties { get set }
}

struct AnyLayoutableView: View, LayoutableView {

    var content: Any

    init(_ content: any View & LayoutableView) {
        self.content = content
    }

    init(@ViewBuilder content: () async -> any View) async {
        self.content = await content()
    }

    var body: some View { noBody }

    var layoutProperties: LayoutProperties {
        get {
            (content as! LayoutableView).layoutProperties
        }
        set {
            var content = content as! LayoutableView
            content.layoutProperties = newValue
            self.content = content
        }
    }
}

extension AnyLayoutableView: PrimitiveView {

    func _render(options: RenderOptions, context: RenderContext) async -> RenderResult {
        await (content as! any View).render(options: options, context: context)
    }
}

struct LayoutModifier: ViewModifier {

    let tag: String
    var layoutProperties: LayoutProperties

    init(tag: String, properties: LayoutProperties) {
        self.tag = tag
        self.layoutProperties = properties
    }

    func body(content: Content) -> some View {
        LayoutView(properties: layoutProperties) { context in
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

extension LayoutModifier: LayoutableView {}

extension ModifiedContent: LayoutableView where Modifier: LayoutableView {

    var layoutProperties: LayoutProperties {
        get { modifier.layoutProperties }
        set { modifier.layoutProperties = newValue }
    }
}

extension ConditionalContent: LayoutableView where TrueContent: LayoutableView, FalseContent: LayoutableView {

    var layoutProperties: LayoutProperties {
        get {
            switch self {
            case .first(let view): view.layoutProperties
            case .second(let view): view.layoutProperties
            }
        }
        set {
            switch self {
            case .first(var view):
                view.layoutProperties = newValue
                self = .first(view)
            case .second(var view):
                view.layoutProperties = newValue
                self = .second(view)
            }
        }
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
        classNames: ClassNames,
        backgroundStyle: AnyShapeStyle?,
        cornerRadius: Float?,
        borderStyle: AnyShapeStyle?,
        options: RenderOptions
    ) async -> some View {
        await UnsafeNode(tag: "table", attributes: attributes(
            classNames: classNames,
            backgroundStyle: backgroundStyle,
            cornerRadius: cornerRadius,
            borderStyle: borderStyle,
            options: options
        )) {
            await AnyView {
                await content(bodyContext)
            }
        }
    }

    private func attributes(
        classNames: ClassNames,
        backgroundStyle: AnyShapeStyle?,
        cornerRadius: Float?,
        borderStyle: AnyShapeStyle?,
        options: RenderOptions
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
        if let cornerRadius {
            styles["border-radius"] = String(Int(cornerRadius)) + "px"
        }
        if let borderStyle {
            styles["border"] = borderStyle
        }
        if !styles.isEmpty {
            attributes.values["style"] = styles
        }
        if !classNames.isEmpty {
            attributes.values["class"] = classNames.renderValue(options: options)
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

    func _render(options: RenderOptions, context: RenderContext) async -> RenderResult {
        var context = context
        context.textSeparator = properties.textSeparator

        let backgroundStyle = context.renderedBackgroundStyle == context.environmentValues.backgroundStyle ? nil : context.environmentValues.backgroundStyle
        context.renderedBackgroundStyle = context.environmentValues.backgroundStyle

        let cornerRadius = context.renderedCornerRadius == context.environmentValues.cornerRadius ? nil : context.environmentValues.cornerRadius
        context.renderedCornerRadius = context.environmentValues.cornerRadius

        let borderStyle = context.renderedBorderStyle == context.environmentValues.borderStyle ? nil : context.environmentValues.borderStyle
        context.renderedBorderStyle = context.environmentValues.borderStyle

        let classNames = context.environmentValues.classNames.subtracting(context.renderedClassName)
        classNames.forEach { context.renderedClassName.insert($0) }

        return await body(
            classNames: classNames,
            backgroundStyle: backgroundStyle,
            cornerRadius: cornerRadius,
            borderStyle: borderStyle,
            options: options
        ).render(options: options, context: context)
    }
}
