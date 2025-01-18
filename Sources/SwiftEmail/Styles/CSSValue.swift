public protocol CSSValue: Sendable {

  func renderCSSValue(environmentValues: EnvironmentValues) -> String
}

extension String: CSSValue {

  public func renderCSSValue(environmentValues: EnvironmentValues) -> String {
    self
  }
}

extension Float: CSSValue {

  public func renderCSSValue(environmentValues: EnvironmentValues) -> String {
    String(Int(self)) + "px"
  }
}

extension Int: CSSValue {

  public func renderCSSValue(environmentValues: EnvironmentValues) -> String {
    String(self) + "px"
  }
}
