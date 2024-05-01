public struct ForEach<Data: RandomAccessCollection, Content: View>: View {

    let elements: Data
    let content: (Data.Element) async -> Content

    public init(_ elements: Data, @ViewBuilder content: @escaping (Data.Element) async -> Content) {
        self.elements = elements
        self.content = content
    }

    public var body: Never { noBody }
}

extension ForEach: PrimitiveView {

    func _render(options: RenderOptions, context: RenderContext) async -> RenderResult {
        let results = await withTaskGroup(of: (Int, RenderResult).self) { group in
            for (index, element) in elements.enumerated() {
                group.addTask {
                    (index, await content(element).render(options: options, context: context))
                }
            }

            var results = [(Int, RenderResult)]()
            results.reserveCapacity(elements.count)
            for await result in group {
                results.append(result)
            }
            return results
                .sorted(by: { $0.0 < $1.0 })
                .map { $0.1 }
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
