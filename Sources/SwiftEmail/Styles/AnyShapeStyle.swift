public struct AnyShapeStyle: ShapeStyle {

  let content: any Sendable
  fileprivate let hash: Int

  public init(_ content: any ShapeStyle) {
    self.content = content
    self.hash = content.hashValue
  }

  public func resolve(in environment: EnvironmentValues) -> Never {
    noResolved
  }
}

extension AnyShapeStyle: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(hash)
  }
}

extension AnyShapeStyle: Equatable {

  public static func == (lhs: AnyShapeStyle, rhs: AnyShapeStyle) -> Bool {
    lhs.hash == rhs.hash
  }
}

extension AnyShapeStyle: PrimitiveShapeStyle {

  func renderRootCSSValue(environmentValues: EnvironmentValues) -> String {
    (content as! any ShapeStyle).renderCSSValue(environmentValues: environmentValues)
  }
}

extension AnyShapeStyle: CSSValue {

  public func renderCSSValue(environmentValues: EnvironmentValues) -> String {
    renderRootCSSValue(environmentValues: environmentValues)
  }
}
