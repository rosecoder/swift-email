protocol PrimitiveShapeStyle {

  func renderRootCSSValue(environmentValues: EnvironmentValues) -> String
}

extension PrimitiveShapeStyle {

  var noResolved: Never {
    fatalError("Must not call resolve directly on a shape style")
  }
}
