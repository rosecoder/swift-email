public struct Email<Content: View>: View {

  public let content: Content

  fileprivate var font = EnvironmentValues.default.font
  fileprivate var foregroundStyle = EnvironmentValues.default.foregroundStyle
  fileprivate var backgroundStyle = EnvironmentValues.default.backgroundStyle

  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    UnsafeNode("<!DOCTYPE html>")
    UnsafeNode(tag: "html") {
      Head {
        UnsafeNode(tag: "meta", attributes: ["charset": "utf-8"])
        UnsafeNode(
          tag: "meta",
          attributes: [
            "http-equiv": "Content-Type",
            "content": "text/html charset=UTF-8",
          ])
        UnsafeNode(
          tag: "meta",
          attributes: [
            "name": "viewport",
            "content": "width=device-width,initial-scale=1.0",
          ])
        UnsafeNode(
          tag: "meta",
          attributes: [
            "name": "color-scheme",
            "content": "light dark",
          ])
        UnsafeNode(
          tag: "meta",
          attributes: [
            "name": "supported-color-schemes",
            "content": "light dark",
          ])
      }
      SwiftEmail.Body {
        content
      }
      .environment(\.font, font)
      .environment(\.foregroundStyle, foregroundStyle)
      .environment(\.backgroundStyle, backgroundStyle)
    }
  }
}

extension Email {

  public func font(_ font: Font) -> Email {
    var email = self
    email.font = font
    return email
  }

  public func fontWeight(_ weight: Font.Weight?) -> some View {
    var email = self
    email.font.weight = weight ?? .regular
    return email
  }

  public func foregroundStyle<Style: ShapeStyle>(_ style: Style) -> Email {
    var email = self
    email.foregroundStyle = AnyShapeStyle(style)
    return email
  }

  public func background<Style: ShapeStyle>(_ style: Style) -> Email {
    var email = self
    email.backgroundStyle = AnyShapeStyle(style)
    return email
  }
}
