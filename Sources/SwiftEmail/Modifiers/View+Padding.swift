extension View {

    public func padding(
        _ edges: Edge.Set = .all,
        _ length: Float? = nil
    ) -> some View {
        padding(EdgeInsets(edges: edges, length: length ?? 20))
    }

    public func padding(_ insets: EdgeInsets) -> some View {
        modifier(LayoutModifier(tag: "padding", properties: LayoutProperties(
            padding: insets
        )))
    }
}
