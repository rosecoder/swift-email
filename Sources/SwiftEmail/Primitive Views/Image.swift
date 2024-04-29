public struct Image: View {

    let source: Source

    var minWidth: Float?
    var idealWidth: Float?
    var maxWidth: Float?

    var minHeight: Float?
    var idealHeight: Float?
    var maxHeight: Float?

    public init(_ source: Source) {
        self.source = source
    }

    public var body: some View {
        ImageSupport()
        UnsafeNode(tag: "img", attributes: attributes(isDark: false))
        UnsafeNode(tag: "img", attributes: attributes(isDark: true))
    }

    private func attributes(isDark: Bool) -> UnsafeNode<EmptyView>.Attributes {
        var attributes: UnsafeNode<EmptyView>.Attributes = [:]
        attributes.values["class"] = isDark ? "_d" : "_l"
        attributes.values["src"] = isDark ? source.darkURL : source.defaultURL
        attributes.values["srcset"] = (isDark ? source.darkAlternatives ?? source.alternatives : source.alternatives)
            .map { $1 + " " + $0 }
            .sorted()
            .joined(separator: ", ")
        if let idealWidth {
            attributes.values["width"] = String(Int(idealWidth))
        }
        if let idealHeight {
            attributes.values["height"] = String(Int(idealHeight))
        }
        return attributes
    }
}

extension Image {

    public struct Source {

        public let defaultURL: String
        public let alternatives: [String: String]

        public let darkURL: String?
        public let darkAlternatives: [String: String]?

        public init(defaultURL: String, alternatives: [String: String] = [:], darkURL: String? = nil, darkAlternatives: [String: String]? = nil) {
            self.defaultURL = defaultURL
            self.alternatives = alternatives
            self.darkURL = darkURL
            self.darkAlternatives = darkAlternatives
        }
    }
}

extension Image {

    public func frame(
        width: Float? = nil,
        height: Float? = nil,
        alignment: Alignment = .center
    ) -> some View {
        var view = self
        if let width {
            view.idealWidth = width
        }
        if let height {
            view.idealHeight = height
        }
        return view
    }

    public func frame(
        minWidth: Float? = nil,
        idealWidth: Float? = nil,
        maxWidth: Float? = nil,
        minHeight: Float? = nil,
        idealHeight: Float? = nil,
        maxHeight: Float? = nil,
        alignment: Alignment? = nil
    ) -> Image {
        var view = self
        if let minWidth {
            view.minWidth = minWidth
        }
        if let idealWidth {
            view.idealWidth = idealWidth
        }
        if let maxWidth {
            view.maxWidth = maxWidth
        }
        if let minHeight {
            view.minHeight = minHeight
        }
        if let idealHeight {
            view.idealHeight = idealHeight
        }
        if let maxHeight {
            view.maxHeight = maxHeight
        }
        return view
    }
}

private struct ImageSupport: View {

    var body: some View { noBody }
}

extension ImageSupport: PrimitiveView {
    
    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        await context.globalStyle.insert(
            key: "display",
            value: "none",
            selector: .className("_l", colorScheme: .dark)
        )
        await context.globalStyle.insert(
            key: "display",
            value: "none",
            selector: .className("_d")
        )
        await context.globalStyle.insert(
            key: "display",
            value: "unset",
            selector: .className("_d", colorScheme: .dark)
        )
        return ""
    }
}
