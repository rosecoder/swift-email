public final class GlobalStyle: View {

    var selectors: [CSSSelector: Styles] = [:]

    func insert(key: String, value: CSSValue, selector: CSSSelector) {
        if var values = selectors[selector] {
            values[key] = value
            selectors[selector] = values
        } else {
            selectors[selector] = Styles(properties: [key: value])
        }
    }

    public nonisolated var body: some View { noBody }
}

private struct GlobalStyleKey: EnvironmentKey {

    static var defaultValue: GlobalStyle { .init() }
}

extension EnvironmentValues {

    var globalStyle: GlobalStyle {
        get { self[GlobalStyleKey.self] }
        set { self[GlobalStyleKey.self] = newValue }
    }
}

private let deferredConstant = "ef2993441110ac1c38501cf51009ce85"

extension GlobalStyle: PrimitiveView {

    nonisolated func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
        .init(html: deferredConstant, text: "")
    }

    nonisolated func renderRootHTMLDeferred(result: inout RenderResult, options: RenderOptions, context: RenderContext) {
        let content = contentWithStyle(options: options, context: context)
        let output = content.render(options: options, context: context).html
        result.html = result.html.replacingOccurrences(of: deferredConstant, with: output)
    }

    @ViewBuilder private func contentWithStyle(options: RenderOptions, context: RenderContext) -> some View {
        let selectors = selectors
        UnsafeNode(tag: "style") {
            UnsafePlainText(".ExternalClass {width:100%;}")

            do {
                let selectors = selectors.filter { $0.key.colorScheme == nil }
                switch options.format {
                case .compact:
                    Self.compact(selectors: selectors, options: options, context: context)
                case .pretty:
                    Self.pretty(selectors: selectors, options: options, context: context)
                }
            }

            ForEach(ColorScheme.allCases) { colorScheme in
                let alternativeContext = {
                    var context = context
                    context.environmentValues.colorScheme = colorScheme
                    context.indentationLevel += 1
                    return context
                }()
                let selectorKeysHavingAlternative = Self.selectorKeysHavingAlternative(
                    selectors: selectors,
                    normal: context.environmentValues,
                    alternative: alternativeContext.environmentValues
                )
                let selectors = selectors.filter { selectorKeysHavingAlternative.contains($0.key) }
                if !selectors.isEmpty {
                    UnsafePlainText("@media (prefers-color-scheme: \(colorScheme.renderCSS())) {")
                    switch options.format {
                    case .compact:
                        Self.compact(selectors: selectors, options: options, context: alternativeContext)
                    case .pretty:
                        Self.pretty(selectors: selectors, options: options, context: alternativeContext)
                    }
                    UnsafePlainText("}")
                }
            }
        }
    }

    private static func selectorKeysHavingAlternative(selectors: [CSSSelector: Styles], normal: EnvironmentValues, alternative: EnvironmentValues) -> Set<CSSSelector> {
        var keys = Set<CSSSelector>()
        for (key, value) in selectors {
            if key.colorScheme == alternative.colorScheme { // quick exit for the selector is implcit for the color scheme
                keys.insert(key)
            } else {
                for property in value.properties {
                    let lhs = property.value.renderCSSValue(environmentValues: normal)
                    let rhs = property.value.renderCSSValue(environmentValues: alternative)
                    if lhs != rhs {
                        keys.insert(key)
                    }
                }
            }
        }
        return keys
    }

    private static func compact(selectors: [CSSSelector: Styles], options: RenderOptions, context: RenderContext) -> some View {
        ForEach(Array(selectors.keys)) { selector in
            UnsafePlainText(selector.renderCSS(options: options) + "{" + (selectors[selector]!.renderCSS(environmentValues: context.environmentValues, isImportant: true)) + "}")
        }
    }

    private static func pretty(selectors: [CSSSelector: Styles], options: RenderOptions, context: RenderContext) -> some View {
        ForEach(Array(selectors.keys).sorted()) { selector in
            let properties = selectors[selector]!.properties
                .map { context.indentation(options: options) + options.indent + options.indent + $0 + ": " + ($1.renderCSSValue(environmentValues: context.environmentValues)) + " !important" }
                .sorted()
                .joined(separator: ";\n") + ";"

            UnsafePlainText(
                selector.renderCSS(options: options) + " {\n" +
                properties + "\n" +
                context.indentation(options: options) + options.indent + "}"
            )
        }
    }
}
