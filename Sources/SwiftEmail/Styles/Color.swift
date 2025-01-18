public struct Color: ShapeStyle {

  let name: String
  let alternatives: [ColorScheme: String]

  public init(_ hex: String) {
    self.name = "#" + hex
    self.alternatives = [:]
  }

  public init(_ hex: String, dark darkHex: String) {
    self.name = "#" + hex
    self.alternatives = [.dark: "#" + darkHex]
  }

  public func resolve(in environment: EnvironmentValues) -> Never {
    noResolved
  }

  var hasAlternative: Bool {
    !alternatives.isEmpty
  }
}

extension Color: PrimitiveShapeStyle {

  func renderRootCSSValue(environmentValues: EnvironmentValues) -> String {
    alternatives[environmentValues.colorScheme] ?? name
  }
}

extension Color {

  public static let background = Color("fff", dark: "000")
  public static let text = Color("000", dark: "fff")

  public static let black = Color("000")
  public static let white = Color("fff")
  public static let gray = Color("808080")
  public static let red = Color("f00")
  public static let green = Color("0f0")
  public static let blue = Color("00f")
}

extension Color: CustomDebugStringConvertible {

  public var debugDescription: String {
    "Color(\(name), alternatives: [\(alternatives.map({ $0.debugDescription + ": " + $1 }).joined(separator: ", "))])"
  }
}
