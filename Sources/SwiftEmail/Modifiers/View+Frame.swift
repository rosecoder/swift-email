extension View {

  public func frame(
    width: Float? = nil,
    height: Float? = nil,
    alignment: Alignment = .center
  ) -> some View {
    modifier(
      LayoutModifier(
        tag: "frame",
        properties: LayoutProperties(
          minWidth: nil,
          idealWidth: width,
          maxWidth: nil,
          minHeight: nil,
          idealHeight: height,
          maxHeight: nil,
          alignment: alignment,
          textSeparator: " "
        )))
  }

  @ViewBuilder public func frame(
    minWidth: Float? = nil,
    idealWidth: Float? = nil,
    maxWidth: Float? = nil,
    minHeight: Float? = nil,
    idealHeight: Float? = nil,
    maxHeight: Float? = nil,
    alignment: Alignment = .center
  ) -> some View {
    if let view = self as? LayoutableView {
      {
        var view = view
        if let minWidth {
          view.layoutProperties.minWidth = minWidth
        }
        if let idealWidth {
          view.layoutProperties.idealWidth = idealWidth
        }
        if let maxWidth {
          view.layoutProperties.maxWidth = maxWidth
        }
        if let minHeight {
          view.layoutProperties.minHeight = minHeight
        }
        if let idealHeight {
          view.layoutProperties.idealHeight = idealHeight
        }
        if let maxHeight {
          view.layoutProperties.maxHeight = maxHeight
        }
        if alignment != .center {
          view.layoutProperties.alignment = alignment
        }
        return AnyLayoutableView(view as! any View & LayoutableView)
      }()
    } else {
      modifier(
        LayoutModifier(
          tag: "frame",
          properties: LayoutProperties(
            minWidth: minWidth,
            idealWidth: idealWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            idealHeight: idealHeight,
            maxHeight: maxHeight,
            alignment: alignment,
            textSeparator: " "
          )))
    }
  }
}
