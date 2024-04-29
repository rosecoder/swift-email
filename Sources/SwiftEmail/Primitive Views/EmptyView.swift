public struct EmptyView: View {

    public init() {}

    public var body: Never { noBody }
}

extension EmptyView: PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) -> String {
        ""
    }
}
