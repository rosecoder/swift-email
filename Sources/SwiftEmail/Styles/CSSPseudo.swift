public enum CSSPseudo {
    case hover
}

extension CSSPseudo {

    func renderCSSPseudo() -> String {
        switch self {
        case .hover:
            return "hover"
        }
    }
}
