struct RenderContext {

    let globalStyle = GlobalStyle()
    var indentationLevel: UInt16 = 0
    var environmentValues: EnvironmentValues = .init()

    var renderedClassName = ClassNames()
    var renderedFont: Font = EnvironmentValues.default.font
    var renderedBackgroundStyle: AnyShapeStyle = EnvironmentValues.default.backgroundStyle
    var renderedForegroundStyle: AnyShapeStyle = EnvironmentValues.default.foregroundStyle
    var renderedCornerRadius = EnvironmentValues.default.cornerRadius
    var renderedBorderStyle: AnyShapeStyle = EnvironmentValues.default.borderStyle
    var renderedUnderline = false
    var renderedTag: AnyHashable?

    func indentation(options: RenderOptions) -> String {
        switch options.format {
        case .compact:
            ""
        case .pretty:
            String(repeating: options.indent, count: Int(indentationLevel))
        }
    }
}
