public struct Divider: View {

  var style: AnyShapeStyle = AnyShapeStyle(Color("D6D3D4"))
  var className: ClassName?

  public init() {}

  public var body: some View { noBody }
}

extension Divider {

  public func overlay<Style: ShapeStyle>(
    _ style: Style,
    file: StaticString = #file,
    line: UInt = #line
  ) -> Divider {
    let className = ClassName(uniqueAt: file, line: line)
    var view = self
    view.style = AnyShapeStyle(style)
    view.className = className
    return view
  }
}

extension Divider: PrimitiveView {

  func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
    let node =
      if let className {
        AnyView(
          UnsafeNode(
            tag: "hr",
            attributes: [
              "style": "border:0;border-top:1px solid "
                + style.renderCSSValue(environmentValues: .current),
              "class": className.renderCSS(options: options),
            ]
          )
          .unsafeGlobalStyle(
            "border-top-color", style as any ShapeStyle,
            selector: .className(className, colorScheme: .dark))
        )
      } else {
        AnyView(
          UnsafeNode(
            tag: "hr",
            attributes: [
              "style": "border:0;border-top:1px solid "
                + style.renderCSSValue(environmentValues: .current)
            ]))
      }

    return .init(
      html: node.render(options: options, context: context).html,
      text: "\n"
    )
  }
}
