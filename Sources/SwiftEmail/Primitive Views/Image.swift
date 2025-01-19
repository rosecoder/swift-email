public struct Image: View {

  let source: Source

  var minWidth: Float?
  var idealWidth: Float?
  var maxWidth: Float?

  var minHeight: Float?
  var idealHeight: Float?
  var maxHeight: Float?

  public init(_ url: String) {
    self.source = .init(defaultURL: url)
  }

  public init(_ source: Source) {
    self.source = source
  }

  public var body: some View { noBody }
}

extension Image: PrimitiveView {

  func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
    if source.darkURL != nil {
      context.globalStyle.insert(
        key: "display",
        value: "none",
        selector: .className("_l", colorScheme: .dark)
      )
      context.globalStyle.insert(
        key: "display",
        value: "none",
        selector: .className("_d")
      )
      context.globalStyle.insert(
        key: "display",
        value: "unset",
        selector: .className("_d", colorScheme: .dark)
      )
    }

    let borderStyle = EnvironmentValues.current.borderStyle
    let needsRenderBorderStyle = context.renderedBorderStyle != borderStyle

    return _Image(
      source: source,
      idealWidth: idealWidth,
      idealHeight: idealHeight,
      borderStyle: needsRenderBorderStyle ? borderStyle : nil,
      environmentValues: .current
    ).render(options: options, context: context)
  }

  private struct _Image: View {

    let source: Source
    let idealWidth: Float?
    let idealHeight: Float?
    let borderStyle: AnyShapeStyle?
    let environmentValues: EnvironmentValues

    var body: some View {
      if source.darkURL == nil {
        UnsafeNode(tag: "img", attributes: attributes(isDark: false, includeClass: false))
      } else {
        UnsafeNode(tag: "img", attributes: attributes(isDark: false, includeClass: true))
        UnsafeNode(tag: "img", attributes: attributes(isDark: true, includeClass: true))
      }
    }

    private func attributes(isDark: Bool, includeClass: Bool) -> UnsafeNode<EmptyView>.Attributes {
      var attributes: UnsafeNode<EmptyView>.Attributes = [:]
      if includeClass {
        attributes.values["class"] = isDark ? "_d" : "_l"
      }
      attributes.values["src"] = isDark ? source.darkURL : source.defaultURL

      let alternatives =
        (isDark ? source.darkAlternatives ?? source.alternatives : source.alternatives)
      if !alternatives.isEmpty {
        attributes.values["srcset"] =
          alternatives
          .map { $1 + " " + $0 }
          .sorted()
          .joined(separator: ", ")
      }

      if let idealWidth {
        attributes.values["width"] = String(Int(idealWidth))
      }
      if let idealHeight {
        attributes.values["height"] = String(Int(idealHeight))
      }
      var style = ""
      if let borderStyle {
        if !style.isEmpty { style += ";" }
        style += "border:" + (borderStyle.renderCSSValue(environmentValues: environmentValues))
      }
      if let contentMode = environmentValues.contentMode {
        if !style.isEmpty { style += ";" }
        switch contentMode {
        case .fill:
          style += "object-fit:cover"
        case .fit:
          style += "object-fit:contain"
        }
      }
      if !style.isEmpty {
        attributes.values["style"] = style
      }
      return attributes
    }
  }
}

extension Image {

  public struct Source: Sendable {

    public let defaultURL: String
    public let alternatives: [String: String]

    public let darkURL: String?
    public let darkAlternatives: [String: String]?

    public init(
      defaultURL: String, alternatives: [String: String] = [:], darkURL: String? = nil,
      darkAlternatives: [String: String]? = nil
    ) {
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
  ) -> Image {
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
