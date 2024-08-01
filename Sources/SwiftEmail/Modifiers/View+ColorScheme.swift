private struct ColorSchemeKey: EnvironmentKey {

    static let defaultValue: ColorScheme = .light
}

extension EnvironmentValues {

    public var colorScheme: ColorScheme {
        get { self[ColorSchemeKey.self] }
        set { self[ColorSchemeKey.self] = newValue }
    }
}
