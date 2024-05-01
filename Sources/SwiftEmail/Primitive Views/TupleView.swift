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

    func renderRootHTML(options: RenderOptions, context: RenderContext) async -> String {
        let results = await withTaskGroup(of: (Int, String).self) { group in
            for (index, element) in children.enumerated() {
                group.addTask {
                    (index, await element.renderHTML(options: options, context: context))
                }
            }

            var results = [(Int, String)]()
            results.reserveCapacity(children.count)
            for await result in group {
                results.append(result)
            }
            return results
                .sorted(by: { $0.0 < $1.0 })
                .map { $0.1 }
                .filter { !$0.isEmpty }
        }

        switch options.format {
        case .compact:
            return results.joined()
        case .pretty:
            return results.joined(separator: "\n")
        }
    }
}
