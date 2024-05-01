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

extension VStack {

    public func frame(
        minWidth: Float? = nil,
        idealWidth: Float? = nil,
        maxWidth: Float? = nil,
        minHeight: Float? = nil,
        idealHeight: Float? = nil,
        maxHeight: Float? = nil,
        alignment: Alignment? = nil
    ) -> VStack {
        var view = self
        if let minWidth {
            view.layoutProperties.minWidth = minWidth
        }
        if let idealWidth {
            view.layoutProperties.idealWidth = idealWidth
        }
        if let maxWidth {
            view.layoutProperties.maxWidth = maxWidth
        }
        if let minHeight {
            view.layoutProperties.minHeight = minHeight
        }
        if let idealHeight {
            view.layoutProperties.idealHeight = idealHeight
        }
        if let maxHeight {
            view.layoutProperties.maxHeight = maxHeight
        }
        if let alignment {
            view.layoutProperties.alignment = alignment
        }
        return view
    }

    public func padding(
        _ edges: Edge.Set = .all,
        _ length: Float? = nil
    ) -> VStack {
        padding(EdgeInsets(edges: edges, length: length ?? 20))
    }

    public func padding(_ insets: EdgeInsets) -> VStack {
        var view = self
        if let old = view.layoutProperties.padding {
            view.layoutProperties.padding = old + insets
        } else {
            view.layoutProperties.padding = insets
        }
        return view
    }
}
