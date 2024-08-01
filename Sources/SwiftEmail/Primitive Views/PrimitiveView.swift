protocol PrimitiveView {

    func _render(options: RenderOptions, taskGroup: inout TaskGroup<Void>, context: RenderContext) -> RenderResult
}

extension PrimitiveView {

    var noBody: Never {
        fatalError("Must not call body directly on a view")
    }
}

extension PrimitiveView where Self: View, Self.Body == Never {

    var body: Body { noBody }
}
