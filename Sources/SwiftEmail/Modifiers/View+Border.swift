private struct BorderStyleKey: EnvironmentKey {

    static var defaultValue: AnyShapeStyle = AnyShapeStyle(Color.black)
}

extension EnvironmentValues {

    public var borderStyle: AnyShapeStyle {
        get { self[BorderStyleKey.self] }
        set { self[BorderStyleKey.self] = newValue }
    }
}

extension View {

    @ViewBuilder public func border<Style: ShapeStyle>(
        _ style: Style,
        width: Float = 1,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        let borderStyle = BorderShapeStyle(style: style, width: width)
        if (style as? Color)?.hasAlternative == false {
            environment(\.borderStyle, AnyShapeStyle(borderStyle))
        } else {
            let className = ClassName(uniqueAt: file, line: line)
            environment(\.borderStyle, AnyShapeStyle(borderStyle))
                .unsafeClass(className)
                .unsafeGlobalStyle("border", borderStyle, selector: .className(className, colorScheme: .dark))
        }
    }

    public func border<Style: ShapeStyle>(
        _ style: Style,
        width: Float = 1,
        when userInteraction: UserInteraction,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        let borderStyle = BorderShapeStyle(style: style, width: width)
        let className = ClassName(uniqueAt: file, line: line)
        return self
            .unsafeClass(className)
            .unsafeGlobalStyle("border", borderStyle, selector: .className(className, pseudo: userInteraction.cssPseudo))
    }
}

public struct BorderShapeStyle<Style: ShapeStyle>: ShapeStyle {

    public let style: Style
    public let width: Float

    public func resolve(in environment: EnvironmentValues) async -> Never {
        noResolved
    }
}

extension BorderShapeStyle: PrimitiveShapeStyle {

    func renderRootCSSValue(environmentValues: EnvironmentValues) async -> String {
        let widthString = String(Int(width)) + "px"
        let styleString = await style.renderCSSValue(environmentValues: environmentValues)
        return "\(widthString) solid \(styleString)"
    }
}
