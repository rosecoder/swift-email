protocol PrimitiveView {

  func _render(options: RenderOptions, context: RenderContext) -> RenderResult
}

extension PrimitiveView {

  var noBody: Never {
    fatalError("Must not call body directly on a view")
  }
}

extension PrimitiveView where Self: View, Self.Body == Never {

  var body: Body { noBody }
}
