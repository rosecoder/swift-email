import Synchronization

public final class GlobalStyle: View, Sendable {

  let selectors = Mutex<[CSSSelector: Styles]>([:])

  func insert(key: String, value: CSSValue, selector: CSSSelector) {
    selectors.withLock {
      if var values = $0[selector] {
        values[key] = value
        $0[selector] = values
      } else {
        $0[selector] = Styles(properties: [key: value])
      }
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

  nonisolated func renderRootHTMLDeferred(
    result: inout RenderResult, options: RenderOptions, context: RenderContext
  ) {
    let content = contentWithStyle(options: options, context: context)
    let output = content.render(options: options, context: context).html
    result.html = result.html.replacingOccurrences(of: deferredConstant, with: output)
  }

  @ViewBuilder private func contentWithStyle(options: RenderOptions, context: RenderContext)
    -> some View
  {
    let selectors = selectors.withLock { $0 }
    UnsafeNode(tag: "style") {
      UnsafePlainText(".ExternalClass {width:100%;}")

      Self.styleNodes(
        selectors: selectors.filter { $0.key.colorScheme == nil },
        options: options,
        context: context,
        environmentValues: .current
      )
      Self.mediaStyleNodes(
        selectors: selectors,
        options: options,
        context: context
      )
    }
  }

  private static func selectorKeysHavingAlternative(
    selectors: [CSSSelector: Styles],
    normal: EnvironmentValues,
    alternative: EnvironmentValues
  ) -> Set<CSSSelector> {
    var keys = Set<CSSSelector>()
    for (key, value) in selectors {
      if key.colorScheme == alternative.colorScheme {  // quick exit for the selector is implcit for the color scheme
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

  @ViewBuilder
  private static func mediaStyleNodes(
    selectors allSelectors: [CSSSelector: Styles],
    options: RenderOptions,
    context: RenderContext
  ) -> some View {
    ForEach(ColorScheme.allCases) { colorScheme in
      let (alternativeContext, alternativeEnvironmentValues): (RenderContext, EnvironmentValues) =
        {
          var context = context
          context.indentationLevel += 1
          var environmentValues = EnvironmentValues.current
          environmentValues.colorScheme = colorScheme
          return (context, environmentValues)
        }()
      let selectorKeysHavingAlternative = Self.selectorKeysHavingAlternative(
        selectors: allSelectors,
        normal: .current,
        alternative: alternativeEnvironmentValues
      )
      let selectors = allSelectors.filter { selectorKeysHavingAlternative.contains($0.key) }
      if !selectors.isEmpty {
        UnsafePlainText("@media (prefers-color-scheme: \(colorScheme.renderCSS())) {")
        Self.styleNodes(
          selectors: selectors,
          options: options,
          context: alternativeContext,
          environmentValues: alternativeEnvironmentValues
        )
        UnsafePlainText("}")
      }
    }
  }

  @ViewBuilder
  private static func styleNodes(
    selectors: [CSSSelector: Styles],
    options: RenderOptions,
    context: RenderContext,
    environmentValues: EnvironmentValues
  ) -> some View {
    switch options.format {
    case .compact:
      Self.compact(
        selectors: selectors,
        options: options,
        context: context,
        environmentValues: environmentValues
      )
    case .pretty:
      Self.pretty(
        selectors: selectors,
        options: options,
        context: context,
        environmentValues: environmentValues
      )
    }
  }

  private static func compact(
    selectors: [CSSSelector: Styles],
    options: RenderOptions,
    context: RenderContext,
    environmentValues: EnvironmentValues
  ) -> some View {
    ForEach(Array(selectors.keys)) { selector in
      UnsafePlainText(
        selector.renderCSS(options: options) + "{"
          + (selectors[selector]!.renderCSS(
            environmentValues: environmentValues, isImportant: true)) + "}")
    }
  }

  private static func pretty(
    selectors: [CSSSelector: Styles],
    options: RenderOptions,
    context: RenderContext,
    environmentValues: EnvironmentValues
  ) -> some View {
    ForEach(Array(selectors.keys).sorted()) { selector in
      let properties =
        selectors[selector]!.properties
        .map {
          context.indentation(options: options) + options.indent + options.indent + $0 + ": "
            + ($1.renderCSSValue(environmentValues: environmentValues)) + " !important"
        }
        .sorted()
        .joined(separator: ";\n") + ";"

      UnsafePlainText(
        selector.renderCSS(options: options) + " {\n" + properties + "\n"
          + context.indentation(options: options) + options.indent + "}"
      )
    }
  }
}
