public protocol ShapeStyle: Hashable {

    associatedtype Resolved: ShapeStyle

    func resolve(in environment: EnvironmentValues) -> Resolved
}
