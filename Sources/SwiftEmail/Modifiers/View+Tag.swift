private struct TagKey: EnvironmentKey {

    static var defaultValue: AnyHashable?
}

extension EnvironmentValues {

    public var tag: AnyHashable? {
        get { self[TagKey.self] }
        set { self[TagKey.self] = newValue }
    }
}

extension View {

    public func tag<Value: Hashable>(_ value: Value) -> some View {
        environment(\.tag, value)
    }
}
