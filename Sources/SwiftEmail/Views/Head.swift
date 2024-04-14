struct Head<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View { noBody }
}

extension Head: PrimitiveView {

    func prerenderRoot(options: HTMLRenderOptions, context: HTMLRenderContext) async {
        await content.prerender(options: options, context: context)
    }

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        let content = await contentWithStyle(options: options, context: context)
        return await content.renderHTML(options: options, context: context)
    }

    @ViewBuilder private func contentWithStyle(options: HTMLRenderOptions, context: HTMLRenderContext) async -> some View {
        await UnsafeNode(tag: "head") {
            content

            let selectors = await context.globalStyle.selectors
            await UnsafeNode(tag: "style") {
                Text(".ExternalClass {width:100%;}")

                do {
                    let selectors = selectors.filter { $0.key.colorScheme == nil }
                    switch options.format {
                    case .compact:
                        compact(selectors: selectors, options: options, context: context)
                    case .pretty:
                        await pretty(selectors: selectors, options: options, context: context)
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
                            compact(selectors: selectors, options: options, context: context)
                        case .pretty:
                            await pretty(selectors: selectors, options: options, context: context)
                        }
                        Text("}")
                    }
                }
            }
        }
    }

    private func compact(selectors: [CSSSelector: Styles], options: HTMLRenderOptions, context: HTMLRenderContext) -> some View {
        ForEach(Array(selectors.keys)) { selector in
            Text(selector.renderCSS(options: options) + "{" + (await selectors[selector]!.renderCSS(environmentValues: context.environmentValues, isImportant: true)) + "}")
        }
    }

    private func pretty(selectors: [CSSSelector: Styles], options: HTMLRenderOptions, context: HTMLRenderContext) async -> some View {
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
