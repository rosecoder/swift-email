public actor GlobalStyle: View {

    var selectors: [CSSSelector: Styles] = [:]

    func insert(key: String, value: CSSValue, selector: CSSSelector) {
        if var values = selectors[selector] {
            values[key] = value
            selectors[selector] = values
        } else {
            selectors[selector] = Styles(properties: [key: value])
        }
    }

    public var body: some View { noBody }
}

private let deferredConstant = "ef2993441110ac1c38501cf51009ce85"

extension GlobalStyle: PrimitiveView {

    nonisolated func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        deferredConstant
    }

    nonisolated func renderRootHTMLDeferred(result: inout String, options: HTMLRenderOptions, context: HTMLRenderContext) async {
        let content = await contentWithStyle(options: options, context: context)
        let output = await content.renderHTML(options: options, context: context)
        result = result.replacingOccurrences(of: deferredConstant, with: output)
    }

    @ViewBuilder private nonisolated func contentWithStyle(options: HTMLRenderOptions, context: HTMLRenderContext) async -> some View {
        let selectors = await selectors
        await UnsafeNode(tag: "style") {
            Text(".ExternalClass {width:100%;}")

            do {
                let selectors = selectors.filter { $0.key.colorScheme == nil }
                switch options.format {
                case .compact:
                    Self.compact(selectors: selectors, options: options, context: context)
                case .pretty:
                    await Self.pretty(selectors: selectors, options: options, context: context)
                }
            }

            ForEach(ColorScheme.allCases) { colorScheme in
                let selectors = selectors.filter { $0.key.colorScheme == colorScheme }
                if !selectors.isEmpty {
                    let context = {
                        var context = context
                        context.environmentValues.colorScheme = colorScheme
                        context.indentationLevel += 1
                        return context
                    }()
                    Text("@media (prefers-color-scheme: \(colorScheme.renderCSS())) {")
                    switch options.format {
                    case .compact:
                        Self.compact(selectors: selectors, options: options, context: context)
                    case .pretty:
                        await Self.pretty(selectors: selectors, options: options, context: context)
                    }
                    Text("}")
                }
            }
        }
    }

    private static func compact(selectors: [CSSSelector: Styles], options: HTMLRenderOptions, context: HTMLRenderContext) -> some View {
        ForEach(Array(selectors.keys)) { selector in
            Text(selector.renderCSS(options: options) + "{" + (await selectors[selector]!.renderCSS(environmentValues: context.environmentValues, isImportant: true)) + "}")
        }
    }

    private static func pretty(selectors: [CSSSelector: Styles], options: HTMLRenderOptions, context: HTMLRenderContext) async -> some View {
        ForEach(Array(selectors.keys).sorted()) { selector in
            let properties = await withTaskGroup(of: String.self) { group in
                let properties = selectors[selector]!.properties
                for (key, value) in properties {
                    group.addTask {
                        context.indentation(options: options) + options.indent + options.indent + key + ": " + (await value.renderCSSValue(environmentValues: context.environmentValues)) + " !important"
                    }
                }

                var results = [String]()
                results.reserveCapacity(properties.count)
                for await result in group {
                    results.append(result)
                }
                return results.sorted().joined(separator: ";\n") + ";"
            }

            Text(
                selector.renderCSS(options: options) + " {\n" +
                properties + "\n" +
                context.indentation(options: options) + options.indent + "}"
            )
        }
    }
}
