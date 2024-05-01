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

    @ViewBuilder public func foregroundStyle<Style: ShapeStyle>(
        _ style: Style,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        if (style as? Color)?.hasAlternative == false {
            environment(\.foregroundStyle, AnyShapeStyle(style))
        } else {
            let className = ClassName(uniqueAt: file, line: line)
            environment(\.foregroundStyle, AnyShapeStyle(style))
                .unsafeClass(className)
                .unsafeGlobalStyle("color", style, selector: .className(className, colorScheme: .dark))
        }
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
