public struct TupleView<Elements>: View, ParentableView {

    public let value: Elements
    let children: [AnyView]

    init<each Content: View>(content: repeat each Content) where Elements == (repeat each Content) {
        self.value = (repeat (each content))

        var elements = [AnyView]()
        func mapElement<T: View>(_ t: T) {
            elements.append(AnyView(t))
        }
        repeat mapElement(each content)
        self.children = elements
    }

    public var body: Never { noBody }
}

extension TupleView: PrimitiveView {

    func _render(options: RenderOptions, context: RenderContext) async -> RenderResult {
        let results = await withTaskGroup(of: (Int, RenderResult).self) { group in
            for (index, element) in children.enumerated() {
                group.addTask {
                    (index, await element.render(options: options, context: context))
                }
            }

            var results = [(Int, RenderResult)]()
            results.reserveCapacity(children.count)
            for await result in group {
                results.append(result)
            }
            return results
                .sorted(by: { $0.0 < $1.0 })
                .map { $0.1 }
                .filter { !$0.html.isEmpty }
        }

        let text = results.map({ $0.text }).filter({ !$0.isEmpty }).joined(separator: context.textSeparator)

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
