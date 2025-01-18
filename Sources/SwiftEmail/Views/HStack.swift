public struct HStack<Content: View>: View {

  public let alignment: VerticalAlignment
  public let spacing: Float?
  public let content: Content

  var layoutProperties: LayoutProperties

  public init(
    alignment: VerticalAlignment = .center,
    spacing: Float? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.alignment = alignment
    self.spacing = spacing
    self.content = content()
    self.layoutProperties = .init(
      alignment: Alignment(horizontal: .center, vertical: alignment),
      textSeparator: " "
    )
  }

  public var body: some View {
    let children: [AnyView] = (content as? ParentableView)?.children ?? [AnyView(content)]

    LayoutView(properties: layoutProperties) { context in
      context.topTR
      UnsafeNode(tag: "tr") {
        context.leadingTD
        ForEach(children.indices) { index in
          if index != 0 {
            UnsafeNode(
              tag: "td",
              attributes: [
                "width": String(Int(spacing ?? 10))
              ]
            ) {
              EmptyView()
            }
          }
          UnsafeNode(
            tag: "td",
            attributes: [
              "valign": alignment.tdAlign
            ]
          ) {
            children[index]
          }
        }
        context.trailingTD
      }
      context.bottomTR
    }
    .tag("HStack")
  }
}

extension HStack: LayoutableView {}
