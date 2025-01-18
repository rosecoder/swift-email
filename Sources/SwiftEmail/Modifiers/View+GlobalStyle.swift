extension View {

  public func unsafeGlobalStyle(
    _ key: String,
    _ value: any ShapeStyle,
    selector: CSSSelector
  ) -> some View {
    GlobalStyleOverride(key: key, value: AnyShapeStyle(value), selector: selector, content: self)
  }

  public func unsafeGlobalStyle(
    _ key: String,
    _ value: CSSValue,
    selector: CSSSelector
  ) -> some View {
    GlobalStyleOverride(key: key, value: value, selector: selector, content: self)
  }
}

private struct GlobalStyleOverride<Content: View>: View {

  let key: String
  let value: CSSValue
  let selector: CSSSelector
  let content: Content
}

extension GlobalStyleOverride: PrimitiveView {

  func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
    context.globalStyle.insert(
      key: key,
      value: value,
      selector: selector
    )
    return content.render(options: options, context: context)
  }
}
