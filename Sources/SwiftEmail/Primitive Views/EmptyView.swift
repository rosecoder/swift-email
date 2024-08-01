public struct EmptyView: View {

    public init() {}

    public var body: Never { noBody }
}

extension EmptyView: PrimitiveView {

    func _render(options: RenderOptions, taskGroup: inout TaskGroup<Void>, context: RenderContext) -> RenderResult {
        .init(html: "", text: "")
    }
}
