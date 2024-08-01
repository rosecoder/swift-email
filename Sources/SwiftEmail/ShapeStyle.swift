public protocol ShapeStyle: Sendable, Hashable {

    associatedtype Resolved: ShapeStyle

    func resolve(in environment: EnvironmentValues) -> Resolved
}
