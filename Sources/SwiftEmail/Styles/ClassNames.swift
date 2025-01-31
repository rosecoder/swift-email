public struct ClassNames: Sendable {

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

  func renderValue(options: RenderOptions) -> String {
    switch options.format {
    case .compact:
      storage
        .map { $0.renderCSS(options: options) }
        .joined(separator: " ")
    case .pretty:
      storage
        .map { $0.renderCSS(options: options) }
        .sorted()
        .joined(separator: " ")
    }
  }
}

extension ClassNames: Hashable {}
extension ClassNames: Equatable {}

extension ClassNames: ExpressibleByStringLiteral {

  public init(stringLiteral value: StaticString) {
    self.init(ClassName(stringLiteral: value))
  }
}
