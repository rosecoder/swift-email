public struct EmptyView: View {

    public init() {}

    public var body: Never { noBody }
}

extension EmptyView: PrimitiveView {

    func prerenderRoot(options: HTMLRenderOptions, context: HTMLRenderContext) async {}

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) -> String {
        ""
    }
}
