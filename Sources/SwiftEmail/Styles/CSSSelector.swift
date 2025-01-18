public struct CSSSelector: Sendable {

  let target: Target
  let pseudo: CSSPseudo?
  let colorScheme: ColorScheme?

  public static func className(
    _ className: ClassName,
    pseudo: CSSPseudo? = nil,
    colorScheme: ColorScheme? = nil
  ) -> Self {
    self.init(target: .className(className), pseudo: pseudo, colorScheme: colorScheme)
  }

  public static func element(
    _ tag: String,
    pseudo: CSSPseudo? = nil,
    colorScheme: ColorScheme? = nil
  ) -> Self {
    self.init(target: .element(tag), pseudo: pseudo, colorScheme: colorScheme)
  }
}

extension CSSSelector: Hashable {}
extension CSSSelector: Equatable {}

extension CSSSelector: Comparable {

  public static func < (lhs: CSSSelector, rhs: CSSSelector) -> Bool {
    let lhsPriority = lhs.pseudo?.priority ?? 0
    let rhsPriority = rhs.pseudo?.priority ?? 0
    if lhsPriority != rhsPriority {
      return lhsPriority < rhsPriority
    }
    return lhs.target < rhs.target
  }
}

extension CSSSelector: CustomDebugStringConvertible {

  public var debugDescription: String {
    "CSSSelector(\(target.debugDescription), pseudo: \(pseudo?.renderCSSPseudo() ?? "nil"), colorScheme: \(colorScheme?.debugDescription ?? "nil"))"
  }
}

extension CSSSelector {

  public enum Target: Sendable {
    case className(ClassName)
    case element(String)
  }
}

extension CSSSelector.Target: Hashable {}
extension CSSSelector.Target: Equatable {}
extension CSSSelector.Target: Comparable {}

extension CSSSelector.Target: CustomDebugStringConvertible {

  public var debugDescription: String {
    switch self {
    case .className(let className):
      return ".className(\(className.debugDescription))"
    case .element(let tag):
      return ".element(\(tag))"
    }
  }
}

extension CSSSelector {

  func renderCSS(options: RenderOptions) -> String {
    var output: String
    switch target {
    case .className(let className):
      output = "." + className.renderCSS(options: options)
    case .element(let tag):
      output = tag
    }
    if let pseudo {
      output += ":" + pseudo.renderCSSPseudo()
    }
    return output
  }
}
