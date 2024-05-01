public enum ColorScheme {
    case light
    case dark
}

extension ColorScheme: Hashable {}
extension ColorScheme: Equatable {}
extension ColorScheme: CaseIterable {}

extension ColorScheme {

    func renderCSS() -> String {
        switch self {
        case .light: "light"
        case .dark: "dark"
        }
    }
}

extension ColorScheme: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .light: "ColorScheme.light"
        case .dark: "ColorScheme.dark"
        }
    }
}
