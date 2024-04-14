extension ShapeStyle {

    func renderCSSValue(environmentValues: EnvironmentValues) async -> String {
        if let primitive = self as? PrimitiveShapeStyle {
            return await primitive.renderRootCSSValue(environmentValues: environmentValues)
        }
        return await resolve(in: environmentValues).renderCSSValue(environmentValues: environmentValues)
    }
}
