public enum UserInteraction {
  case hover
  case active
}

extension UserInteraction {

  var cssPseudo: CSSPseudo {
    switch self {
    case .hover: .hover
    case .active: .active
    }
  }
}
