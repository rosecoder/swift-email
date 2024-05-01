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

private struct GlobalStyleKey: EnvironmentKey {

    static var defaultValue: GlobalStyle = .init()
}

extension EnvironmentValues {

    var globalStyle: GlobalStyle {
        get { self[GlobalStyleKey.self] }
        set { self[GlobalStyleKey.self] = newValue }
    }
}

private let deferredConstant = "ef2993441110ac1c38501cf51009ce85"

extension GlobalStyle: PrimitiveView {

    nonisolated func _render(options: RenderOptions, context: RenderContext) async -> RenderResult {
        .init(html: deferredConstant, text: "")
    }

    nonisolated func renderRootHTMLDeferred(result: inout RenderResult, options: RenderOptions, context: RenderContext) async {
        let content = await contentWithStyle(options: options, context: context)
        let output = await content.render(options: options, context: context).html
        result.html = result.html.replacingOccurrences(of: deferredConstant, with: output)
    }

    @ViewBuilder private nonisolated func contentWithStyle(options: RenderOptions, context: RenderContext) async -> some View {
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
                let alternativeContext = {
                    var context = context
                    context.environmentValues.colorScheme = colorScheme
                    context.indentationLevel += 1
                    return context
                }()
                let selectorKeysHavingAlternative = await Self.selectorKeysHavingAlternative(
                    selectors: selectors,
                    normal: context.environmentValues,
                    alternative: alternativeContext.environmentValues
                )
                let selectors = selectors.filter { selectorKeysHavingAlternative.contains($0.key) }
                if !selectors.isEmpty {
                    Text("@media (prefers-color-scheme: \(colorScheme.renderCSS())) {")
                    switch options.format {
                    case .compact:
                        Self.compact(selectors: selectors, options: options, context: alternativeContext)
                    case .pretty:
                        await Self.pretty(selectors: selectors, options: options, context: alternativeContext)
                    }
                    Text("}")
                }
            }
        }
    }

    private static func selectorKeysHavingAlternative(selectors: [CSSSelector: Styles], normal: EnvironmentValues, alternative: EnvironmentValues) async -> Set<CSSSelector> {
        await withTaskGroup(of: CSSSelector?.self) { group in
            var keys = Set<CSSSelector>()
            for (key, value) in selectors {
                if key.colorScheme == alternative.colorScheme { // quick exit for the selector is implcit for the color scheme
                    keys.insert(key)
                } else {
                    group.addTask {
                        for property in value.properties {
                            async let lhs = property.value.renderCSSValue(environmentValues: normal)
                            async let rhs = property.value.renderCSSValue(environmentValues: alternative)
                            let lhsValue = await lhs
                            let rhsValue = await rhs
                            if lhsValue != rhsValue {
                                return key
                            }
                        }
                        return nil
                    }
                }
            }
            for await key in group {
                if let key {
                    keys.insert(key)
                }
            }
            return keys
        }
    }

    private static func compact(selectors: [CSSSelector: Styles], options: RenderOptions, context: RenderContext) -> some View {
        ForEach(Array(selectors.keys)) { selector in
            Text(selector.renderCSS(options: options) + "{" + (await selectors[selector]!.renderCSS(environmentValues: context.environmentValues, isImportant: true)) + "}")
        }
    }

    private static func pretty(selectors: [CSSSelector: Styles], options: RenderOptions, context: RenderContext) async -> some View {
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
