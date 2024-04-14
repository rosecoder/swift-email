private struct ForegroundStyleKey: EnvironmentKey {

    static var defaultValue: AnyShapeStyle = AnyShapeStyle(Color.text)
}

extension EnvironmentValues {

    public var foregroundStyle: AnyShapeStyle {
        get { self[ForegroundStyleKey.self] }
        set { self[ForegroundStyleKey.self] = newValue }
    }
}

extension View {

    public func foregroundStyle<Style: ShapeStyle>(_ style: Style) -> some View {
        self
            .unsafeStyle("color", style)
            .environment(\.foregroundStyle, AnyShapeStyle(style))
    }

    public func foregroundStyle<Style: ShapeStyle>(
        _ style: Style,
        when userInteraction: UserInteraction,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        let className = ClassName(uniqueAt: file, line: line)
        return self
            .unsafeClass(className)
            .unsafeGlobalStyle("color", style, selector: .className(className, pseudo: userInteraction.cssPseudo))
    }
}
