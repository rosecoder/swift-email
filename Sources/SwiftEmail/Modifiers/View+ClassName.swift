private struct ClassNameKey: EnvironmentKey {

    static var defaultValue: ClassName?
}

extension EnvironmentValues {

    public var className: ClassName? {
        get { self[ClassNameKey.self] }
        set { self[ClassNameKey.self] = newValue }
    }
}

extension View {

    public func unsafeClass(_ className: ClassName) -> some View {
        environment(\.className, className)
    }
}
