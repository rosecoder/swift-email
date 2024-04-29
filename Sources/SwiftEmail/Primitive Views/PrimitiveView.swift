protocol PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String
}

extension PrimitiveView {

    var noBody: Never {
        fatalError("Must not call body directly on a view")
    }
}

extension PrimitiveView where Self: View, Self.Body == Never {

    var body: Body { noBody }
}
