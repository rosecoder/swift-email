public enum UnsafeNode<Content: View>: View {
    case html(StaticString)
    case closed(tag: StaticString, Attributes)
    case content(tag: StaticString, Attributes, Content)

    public init(
        tag: StaticString,
        attributes: Attributes = [:],
        @ViewBuilder content: () -> Content
    ) {
        self = .content(tag: tag, attributes, content())
    }

    public init(
        tag: StaticString,
        attributes: Attributes = [:],
        @ViewBuilder content: () async -> Content
    ) async {
        self = .content(tag: tag, attributes, await content())
    }

    public var body: Never { noBody }
}

extension UnsafeNode where Content == EmptyView {

    public init(_ html: StaticString) {
        self = .html(html)
    }

    public init(tag: StaticString, attributes: Attributes = [:]) {
        self = .closed(tag: tag, attributes)
    }
}

extension UnsafeNode: PrimitiveView {

    func renderRootHTML(options: RenderOptions, context: RenderContext) async -> String {
        let indentation = context.indentation(options: options)
        switch self {
        case .html(let html):
            return indentation + String(describing: html)

        case .closed(let tag, var attributes):
            let tag = String(describing: tag)
            var context = context
            if options.format == .pretty, let debugTag = context.environmentValues.tag, context.renderedTag != debugTag {
                attributes.values["data-tag"] = String(describing: debugTag)
                context.renderedTag = debugTag
            }
            let attributesString = await attributes.renderHTML(options: options, context: context)
            switch options.format {
            case .compact:
                return indentation + "<" + tag + attributesString + "/>"
            case .pretty:
                return indentation + "<" + tag + attributesString + " />"
            }

        case .content(let tag, var attributes, let content):
            let tag = String(describing: tag)
            var context = context
            if options.format == .pretty, let debugTag = context.environmentValues.tag, context.renderedTag != debugTag {
                attributes.values["data-tag"] = String(describing: debugTag)
                context.renderedTag = debugTag
            }
            let attributesString = await attributes.renderHTML(options: options, context: context)

            context.indentationLevel += 1
            let content = await content.renderHTML(options: options, context: context)

            switch options.format {
            case .compact:
                return "<" + tag + attributesString + ">" +
                           content +
                       "</" + tag + ">"
            case .pretty:
                if content == "" {
                    return indentation + "<" + tag + attributesString + "></" + tag + ">"
                }
                return indentation + "<" + tag + attributesString + ">\n" +
                           content + "\n" +
                       indentation + "</" + tag + ">"
            }
        }
    }
}
