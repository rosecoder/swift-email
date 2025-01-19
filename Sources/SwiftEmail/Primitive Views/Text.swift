import Foundation

public struct Text: View {

  enum Storage {
    case verbatim(String)
    case localized(LocalizedStringKey, Bundle?)
  }

  let storage: Storage

  public init(_ key: LocalizedStringKey, bundle: Bundle? = nil, comment: StaticString? = nil) {
    self.storage = .localized(key, bundle)
  }

  public init(verbatim value: String) {
    self.storage = .verbatim(value)
  }

  public init<S: StringProtocol>(_ content: S) {
    self.storage = .verbatim(String(content))
  }

  public var body: some View { noBody }
}

extension Text: PrimitiveView {

  func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
    var context = context
    let environmentValues = EnvironmentValues.current

    let font = environmentValues.font
    let needsRenderFont = context.renderedFont != font
    context.renderedFont = font

    let backgroundStyle = environmentValues.backgroundStyle
    let needsRenderBackgroundStyle = context.renderedBackgroundStyle != backgroundStyle
    context.renderedBackgroundStyle = backgroundStyle

    let foregroundStyle = environmentValues.foregroundStyle
    let needsRenderForegroundStyle = context.renderedForegroundStyle != foregroundStyle
    context.renderedForegroundStyle = foregroundStyle

    let cornerRadius = environmentValues.cornerRadius
    let needsRenderCornerRadius = context.renderedCornerRadius != cornerRadius
    context.renderedCornerRadius = cornerRadius

    let borderStyle = environmentValues.borderStyle
    let needsRenderBorderStyle = context.renderedBorderStyle != borderStyle
    context.renderedBorderStyle = borderStyle

    let classNames = environmentValues.classNames.subtracting(context.renderedClassName)
    classNames.forEach { context.renderedClassName.insert($0) }

    let underline = environmentValues.underline
    let needsRenderUnderline = context.renderedUnderline != underline
    context.renderedUnderline = underline

    var style = ""
    if needsRenderBackgroundStyle {
      if !style.isEmpty { style += ";" }
      style +=
        "background:" + backgroundStyle.renderCSSValue(environmentValues: environmentValues)
    }
    if needsRenderForegroundStyle {
      if !style.isEmpty { style += ";" }
      style +=
        "color:" + foregroundStyle.renderCSSValue(environmentValues: environmentValues)
    }
    if needsRenderCornerRadius {
      if !style.isEmpty { style += ";" }
      style += "border-radius:" + String(Int(cornerRadius)) + "px"
    }
    if needsRenderBorderStyle {
      if !style.isEmpty { style += ";" }
      style += "border:" + borderStyle.renderCSSValue(environmentValues: environmentValues)
    }
    if needsRenderUnderline {
      if !style.isEmpty { style += ";" }
      style += "text-decoration:" + (underline ? "underline" : "none")
    }

    // Rendering font may require inserts of multiple nodes for accessbility (bold and italic)
    if needsRenderFont {
      if !style.isEmpty { style += ";" }
      return body(
        style: style,
        classNames: classNames,
        options: options,
        context: context
      )
      .render(options: options, context: context)
    }

    // Wrap in span-node if any styling or class name needs to be applied
    if !style.isEmpty || !classNames.isEmpty {
      var attributes: UnsafeNode<PlainText>.Attributes = [
        "style": style
      ]
      if !classNames.isEmpty {
        attributes.values["class"] = classNames.renderValue(options: options)
      }
      return UnsafeNode(tag: "span", attributes: attributes) {
        PlainText(getPlainString(context: context))
      }
      .render(options: options, context: context)
    }

    // No styling, just return plain text
    return PlainText(getPlainString(context: context))
      .render(options: options, context: context)
  }

  @ViewBuilder private func body(
    style: String,
    classNames: ClassNames,
    options: RenderOptions,
    context: RenderContext
  ) -> some View {
    let environmentValues = EnvironmentValues.current
    let font = environmentValues.font
    let size: String = "\(font.size)px"
    let weight: String = font.weight.renderCSSValue(environmentValues: environmentValues)
    let name: String = font.name
    let isBold = font.weight.isBold
    let isItalic = font.isItalic
    var style = style + "font-size:\(size);font-weight:\(weight);font-family:\(name)"
    if isItalic {
      let _ = {
        style += ";font-style:italic"
      }()
    }
    var attributes: UnsafeNode<PlainText>.Attributes = [
      "style": style
    ]
    if !classNames.isEmpty {
      let _ = {
        attributes.values["class"] = classNames.renderValue(options: options)
      }()
    }
    if isBold && isItalic {
      UnsafeNode(tag: "i") {
        UnsafeNode(tag: "b", attributes: attributes) {
          PlainText(getPlainString(context: context))
        }
      }
    } else {
      UnsafeNode(tag: isBold ? "b" : isItalic ? "i" : "span", attributes: attributes) {
        PlainText(getPlainString(context: context))
      }
    }
  }

  private func getPlainString(context: RenderContext) -> String {
    switch storage {
    case .verbatim(let string):
      return string
    case .localized(let key, let bundle):
      return LocalizedStringsService.shared.translated(
        key: key, bundle: bundle ?? .main, locale: EnvironmentValues.current.locale)
    }
  }
}
