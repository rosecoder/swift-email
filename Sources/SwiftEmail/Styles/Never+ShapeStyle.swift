extension Never: ShapeStyle {

    public typealias Resolved = Never

    public func resolve(in environment: EnvironmentValues) -> Never {
        fatalError()
    }
}
