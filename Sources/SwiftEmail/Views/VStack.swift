public struct VStack<Content: View>: View {

    public let alignment: HorizontalAlignment
    public let spacing: Float?
    public let content: Content

    var layoutProperties: LayoutProperties

    public init(
        alignment: HorizontalAlignment = .center,
        spacing: Float? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
        self.layoutProperties = .init(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            textSeparator: "\n"
        )
    }

    public var body: some View {
        let children: [AnyView] = (content as? ParentableView)?.children ?? [AnyView(content)]

        LayoutView(properties: layoutProperties) { context in
            context.topTR
            ForEach(children.indices) { index in
                if index != 0 {
                    UnsafeNode(tag: "tr") {
                        UnsafeNode(tag: "td", attributes: [
                            "height": String(Int(spacing ?? 10)),
                        ]) {
                            EmptyView()
                        }
                    }
                }
                UnsafeNode(tag: "tr", attributes: [
                    "align": alignment.tdAlign,
                ]) {
                    context.leadingTD
                    UnsafeNode(tag: "td") {
                        children[index]
                    }
                    context.trailingTD
                }
            }
            context.bottomTR
        }
        .tag("VStack")
    }
}

extension VStack: LayoutableView {}
