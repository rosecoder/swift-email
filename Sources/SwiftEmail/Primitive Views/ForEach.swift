public struct ForEach<Data: RandomAccessCollection, Content: View>: View {

  let elements: Data
  let content: (Data.Element) -> Content

  public init(_ elements: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
    self.elements = elements
    self.content = content
  }

  public var body: Never { noBody }
}

extension ForEach: PrimitiveView {

  func _render(options: RenderOptions, context: RenderContext) -> RenderResult {
    let results = elements.map {
      content($0).render(options: options, context: context)
    }

    let text = results.map({ $0.text }).filter({ !$0.isEmpty }).joined(
      separator: context.textSeparator)

    switch options.format {
    case .compact:
      return .init(
        html: results.map({ $0.html }).joined(),
        text: text
      )
    case .pretty:
      return .init(
        html: results.map({ $0.html }).joined(separator: "\n"),
        text: text
      )
    }
  }
}
