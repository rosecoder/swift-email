public struct Alignment {

    public var horizontal: HorizontalAlignment
    public var vertical: VerticalAlignment

    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

extension Alignment: Equatable {}

extension Alignment {

    public static let center = Alignment(horizontal: .center, vertical: .center)
}
