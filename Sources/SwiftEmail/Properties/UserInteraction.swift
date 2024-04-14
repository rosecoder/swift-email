public enum UserInteraction {
    case hover
}

extension UserInteraction {

    var cssPseudo: CSSPseudo {
        switch self {
        case .hover: .hover
        }
    }
}
