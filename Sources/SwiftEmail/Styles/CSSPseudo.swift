public enum CSSPseudo: Sendable {
    case hover
    case active
}

extension CSSPseudo {

    func renderCSSPseudo() -> String {
        switch self {
        case .hover:
            return "hover"
        case .active:
            return "active"
        }
    }

    var priority: Int {
        switch self {
        case .hover:
            return 1
        case .active:
            return 2
        }
    }
}
