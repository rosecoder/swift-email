public struct ClassNames {

    private var storage: Set<ClassName>

    public init(_ classNames: Set<ClassName> = []) {
        self.storage = classNames
    }

    public init(_ className: ClassName) {
        self.storage = [className]
    }

    mutating func insert(_ newMember: ClassName) {
        storage.insert(newMember)
    }

    func subtracting(_ other: ClassNames) -> ClassNames {
        ClassNames(storage.subtracting(other.storage))
    }

    var isEmpty: Bool {
        storage.isEmpty
    }

    func forEach(_ body: (ClassName) throws -> Void) rethrows {
        try storage.forEach(body)
    }

    func renderValue(options: HTMLRenderOptions) -> String {
        storage
            .map { $0.renderCSS(options: options) }
            .joined(separator: " ")
    }
}

extension ClassNames: Hashable {}
extension ClassNames: Equatable {}

extension ClassNames: ExpressibleByStringLiteral {

    public init(stringLiteral value: StaticString) {
        self.init(ClassName(stringLiteral: value))
    }
}
