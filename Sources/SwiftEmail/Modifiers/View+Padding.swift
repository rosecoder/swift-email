extension View {

  public func padding(
    _ edges: Edge.Set = .all,
    _ length: Float? = nil
  ) -> some View {
    padding(EdgeInsets(edges: edges, length: length ?? 20))
  }

  @ViewBuilder public func padding(_ insets: EdgeInsets) -> some View {
    if let view = self as? LayoutableView {
      {
        var view = view
        if let old = view.layoutProperties.padding {
          view.layoutProperties.padding = old + insets
        } else {
          view.layoutProperties.padding = insets
        }
        return AnyLayoutableView(view as! any View & LayoutableView)
      }()
    } else {
      modifier(
        LayoutModifier(
          tag: "padding",
          properties: LayoutProperties(
            padding: insets,
            textSeparator: " "
          )))
    }
  }
}
