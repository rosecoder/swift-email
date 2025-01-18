extension ShapeStyle {

  func renderCSSValue(environmentValues: EnvironmentValues) -> String {
    if let primitive = self as? PrimitiveShapeStyle {
      return primitive.renderRootCSSValue(environmentValues: environmentValues)
    }
    return resolve(in: environmentValues).renderCSSValue(environmentValues: environmentValues)
  }
}
