public enum HorizontalAlignment: Sendable {
  case leading
  case center
  case trailing
}

extension HorizontalAlignment {

  var tdAlign: String {
    switch self {
    case .leading:
      return "left"
    case .center:
      return "center"
    case .trailing:
      return "right"
    }
  }
}
