private struct BackgroundStyleKey: EnvironmentKey {

    static let defaultValue: AnyShapeStyle = AnyShapeStyle(Color.background)
}

extension EnvironmentValues {

    public var backgroundStyle: AnyShapeStyle {
        get { self[BackgroundStyleKey.self] }
        set { self[BackgroundStyleKey.self] = newValue }
    }
}

extension View {

    @ViewBuilder public func background<Style: ShapeStyle>(
        _ style: Style,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        if (style as? Color)?.hasAlternative == false {
            environment(\.backgroundStyle, AnyShapeStyle(style))
        } else {
            let className = ClassName(uniqueAt: file, line: line)
            environment(\.backgroundStyle, AnyShapeStyle(style))
                .unsafeClass(className)
                .unsafeGlobalStyle("background", style, selector: .className(className, colorScheme: .dark))
        }
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
