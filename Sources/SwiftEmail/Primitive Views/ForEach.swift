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

    func renderRootHTML(options: RenderOptions, context: RenderContext) async -> String {
        let results = await withTaskGroup(of: (Int, String).self) { group in
            for (index, element) in elements.enumerated() {
                group.addTask {
                    (index, await content(element).renderHTML(options: options, context: context))
                }
            }

            var results = [(Int, String)]()
            results.reserveCapacity(elements.count)
            for await result in group {
                results.append(result)
            }
            return results
                .sorted(by: { $0.0 < $1.0 })
                .map { $0.1 }
        }

        switch options.format {
        case .compact:
            return results.joined()
        case .pretty:
            return results.joined(separator: "\n")
        }
    }
}
