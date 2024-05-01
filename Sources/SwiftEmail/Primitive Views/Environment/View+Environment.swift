extension View {

    public func environment<V>(
        _ keyPath: WritableKeyPath<EnvironmentValues, V>,
        _ value: V
    ) -> some View {
        EnvironmentOverride(keyPath: keyPath, value: value, content: self)
    }
}

struct EnvironmentOverride<Content: View, Value>: View {

    let keyPath: WritableKeyPath<EnvironmentValues, Value>
    let value: Value
    let content: Content
}

extension EnvironmentOverride: PrimitiveView {

    func _render(options: RenderOptions, context: RenderContext) async -> RenderResult {
        var context = context
        context.environmentValues[keyPath: keyPath] = value
        return await content.render(options: options, context: context)
    }
}
