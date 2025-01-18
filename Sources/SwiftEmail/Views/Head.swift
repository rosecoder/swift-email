struct Head<Content: View>: View {

  @Environment(\.globalStyle) private var globalStyle

  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    UnsafeNode(tag: "head") {
      content
      globalStyle
    }
  }
}
