public struct EmptyView: View {

    public init() {}

    public var body: Never { noBody }
}

extension EmptyView: PrimitiveView {

    func renderRootHTML(options: RenderOptions, context: RenderContext) -> String {
        ""
    }
}
