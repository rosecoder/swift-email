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

    func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
        (content as! any View).render(options: options, context: context)
    }
}
