private struct UnderlineKey: EnvironmentKey {

    static var defaultValue = false
}

extension EnvironmentValues {

    public var underline: Bool {
        get { self[UnderlineKey.self] }
        set { self[UnderlineKey.self] = newValue }
    }
}

extension View {

    public func underline(_ isActive: Bool = true) -> some View {
        environment(\.underline, isActive)
    }

    public func underline(
        _ isActive: Bool = true,
        when userInteraction: UserInteraction,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        let className = ClassName(uniqueAt: file, line: line)
        return self
            .unsafeClass(className)
            .unsafeGlobalStyle("text-decoration", isActive ? "underline" : "none", selector: .className(className, pseudo: userInteraction.cssPseudo))
    }
}
