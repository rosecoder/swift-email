private struct FontKey: EnvironmentKey {

    static var defaultValue: Font = .system
}

extension EnvironmentValues {

    public var font: Font {
        get { self[FontKey.self] }
        set { self[FontKey.self] = newValue }
    }
}

extension View {

    public func font(_ font: Font) -> some View {
        environment(\.font, font)
    }

    public func fontWeight(_ weight: Font.Weight?) -> some View {
        modifier(FontWeightModifier(weight: weight))
    }
}

private struct FontWeightModifier: ViewModifier {

    @Environment(\.font) private var font

    let weight: Font.Weight?

    func body(content: Content) -> some View {
        content
            .font({
                var font = font
                font.weight = weight ?? .regular
                return font
            }())
    }
}
