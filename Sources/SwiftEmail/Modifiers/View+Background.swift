private struct BackgroundStyleKey: EnvironmentKey {

    static var defaultValue: AnyShapeStyle = AnyShapeStyle(Color.background)
}

extension EnvironmentValues {

    public var backgroundStyle: AnyShapeStyle {
        get { self[BackgroundStyleKey.self] }
        set { self[BackgroundStyleKey.self] = newValue }
    }
}

extension View {

    public func background<Style: ShapeStyle>(_ style: Style) -> some View {
        environment(\.backgroundStyle, AnyShapeStyle(style))
    }

    public func background<Style: ShapeStyle>(
        _ style: Style,
        when userInteraction: UserInteraction,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        let className = ClassName(uniqueAt: file, line: line)
        return self
            .unsafeClass(className)
            .unsafeGlobalStyle("background", style, selector: .className(className, pseudo: userInteraction.cssPseudo))
    }
}
