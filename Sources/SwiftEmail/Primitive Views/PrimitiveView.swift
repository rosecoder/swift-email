protocol PrimitiveView {

    func prerenderRoot(options: HTMLRenderOptions, context: HTMLRenderContext) async
    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String
}

extension PrimitiveView {

    var noBody: Never {
        fatalError("Must not call body directly on a view")
    }
}
