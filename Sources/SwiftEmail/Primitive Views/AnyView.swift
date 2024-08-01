public struct AnyView: View {

    let content: Any

    public init(_ content: any View) {
        self.content = content
    }

    init(@ViewBuilder content: () -> any View) {
        self.content = content()
    }

    public var body: some View { noBody }
}

extension AnyView: PrimitiveView {

    func _render(options: RenderOptions, taskGroup: inout TaskGroup<Void>, context: RenderContext) -> RenderResult {
        (content as! any View).render(options: options, taskGroup: &taskGroup, context: context)
    }
}
