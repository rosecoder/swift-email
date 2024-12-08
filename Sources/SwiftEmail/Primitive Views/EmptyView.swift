public struct EmptyView: View {

    public init() {}

    public var body: Never { noBody }
}

extension EmptyView: PrimitiveView {

    func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
        .init(html: "", text: "")
    }
}
