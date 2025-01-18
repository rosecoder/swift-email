extension Font {

  public enum Weight: Sendable {
    case black
    case bold
    case heavy
    case light
    case medium
    case regular
    case semibold
    case thin
    case ultraLight

    var isBold: Bool {
      switch self {
      case .black, .bold, .heavy, .semibold:
        return true
      case .regular, .medium, .light, .thin, .ultraLight:
        return false
      }
    }
  }
}

extension Font.Weight: Equatable {}

extension Font.Weight: CSSValue {

  public func renderCSSValue(environmentValues: EnvironmentValues) -> String {
    switch self {
    case .black: "900"
    case .bold: "700"
    case .heavy: "800"
    case .light: "300"
    case .medium: "500"
    case .regular: "400"
    case .semibold: "600"
    case .thin: "100"
    case .ultraLight: "200"
    }
  }
}
