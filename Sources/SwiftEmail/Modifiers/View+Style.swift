extension View {

    public func unsafeStyle(_ key: String, _ value: any CSSValue) -> some View {
        unsafeStyle(key, { await value.renderCSSValue(environmentValues: $0) })
    }

    public func unsafeStyle(_ key: String, _ value: any ShapeStyle) -> some View {
        unsafeStyle(key, { await value.renderCSSValue(environmentValues: $0) })
    }

    private func unsafeStyle(_ key: String, _ value: @escaping (EnvironmentValues) async -> String) -> some View {
        StyleOverride(values: [
            key: value,
        ], content: self)
    }
}

struct StyleOverride<Content: View>: View {

    let values: [String: (EnvironmentValues) async -> String]
    let content: Content

    var body: some View { noBody }
}

extension StyleOverride: PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        let style = await withTaskGroup(of: String.self) { group in
            for (key, value) in values {
                group.addTask {
                    let value = await value(context.environmentValues)
                    return key + ":" + value
                }
            }

            var results = [String]()
            results.reserveCapacity(values.count)
            for await result in group {
                results.append(result)
            }
            return results
        }

        let node = UnsafeNode(tag: "span", attributes: [
            "style": style.joined(separator: ";")
        ]) {
            content
        }
        return await node.renderRootHTML(options: options, context: context)
    }
}
