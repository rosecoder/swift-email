extension Edge {

    public struct Set: Sendable {

        let values: Swift.Set<Edge>

        init(_ values: Swift.Set<Edge>) {
            self.values = values
        }
    }
}

extension Edge.Set {

    public static let all = Edge.Set([.top, .bottom, .leading, .trailing])
    public static let top = Edge.Set([.top])
    public static let bottom = Edge.Set([.bottom])
    public static let leading = Edge.Set([.leading])
    public static let trailing = Edge.Set([.trailing])
    public static let horizontal = Edge.Set([.trailing, .leading])
    public static let vertical = Edge.Set([.top, .bottom])
}
