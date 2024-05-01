extension View {

    public func frame(
        width: Float? = nil,
        height: Float? = nil,
        alignment: Alignment = .center
    ) -> some View {
        modifier(LayoutModifier(tag: "frame", properties: LayoutProperties(
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

    public func frame(
        minWidth: Float? = nil,
        idealWidth: Float? = nil,
        maxWidth: Float? = nil,
        minHeight: Float? = nil,
        idealHeight: Float? = nil,
        maxHeight: Float? = nil,
        alignment: Alignment = .center
    ) -> some View {
        modifier(LayoutModifier(tag: "frame", properties: LayoutProperties(
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
