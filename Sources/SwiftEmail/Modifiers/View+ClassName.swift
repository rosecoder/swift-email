private struct ClassNameKey: EnvironmentKey {

    static let defaultValue = ClassNames()
}

extension EnvironmentValues {

    public var classNames: ClassNames {
        get { self[ClassNameKey.self] }
        set { self[ClassNameKey.self] = newValue }
    }
}

extension View {

    public func unsafeClass(_ className: ClassName) -> some View {
        modifier(ClassModifier(className: className))
    }
}

private struct ClassModifier: ViewModifier {

    @Environment(\.classNames) private var classNames

    let className: ClassName

    func body(content: Content) -> some View {
        content
            .environment(\.classNames, {
                var classNames = self.classNames
                classNames.insert(className)
                return classNames
            }())
    }
}
