public enum VerticalAlignment: Sendable {
    case top
    case center
    case bottom
}

extension VerticalAlignment {

    var tdAlign: String {
        switch self {
        case .top:
            return "top"
        case .center:
            return "middle"
        case .bottom:
            return "bottom"
        }
    }
}
