public struct RenderOptions: Sendable {

    public enum Format: Sendable {
        case compact
        case pretty
    }

    public var format: Format
    public var indent: String

    public init(
        format: Format = .compact,
        indent: String = "  "
    ) {
        self.format = format
        self.indent = indent
    }
}

private struct RenderOptionsKey: EnvironmentKey {

    static let defaultValue: RenderOptions = .init()
}

extension EnvironmentValues {

    var renderOptions: RenderOptions {
        get { self[RenderOptionsKey.self] }
        set { self[RenderOptionsKey.self] = newValue }
    }
}
