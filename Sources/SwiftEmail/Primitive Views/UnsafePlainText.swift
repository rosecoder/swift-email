public struct UnsafePlainText: View {

    let value: String

    public init(_ value: String) {
        self.value = value
    }

    public var body: Never { noBody }
}

extension UnsafePlainText: PrimitiveView {

    func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
        .init(
            html: context.indentation(options: options) + value,
            text: value
        )
    }
}
