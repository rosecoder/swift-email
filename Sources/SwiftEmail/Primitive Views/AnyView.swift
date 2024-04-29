public struct AnyView: View {

    let content: Any

    public init(_ content: any View) {
        self.content = content
    }

    init(@ViewBuilder content: () async -> any View) async {
        self.content = await content()
    }

    public var body: some View { noBody }
}

extension AnyView: PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        await (content as! any View).renderHTML(options: options, context: context)
    }
}
