private struct TagKey: EnvironmentKey {

  static let defaultValue: Tag? = nil
}

public struct Tag: Sendable, Hashable, CustomStringConvertible {

  let tag: any Sendable

  public static func == (lhs: Tag, rhs: Tag) -> Bool {
    (lhs.tag as! AnyHashable) == (rhs.tag as! AnyHashable)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(tag as! AnyHashable)
  }

  public var description: String {
    String(describing: tag)
  }
}

extension EnvironmentValues {

  public var tag: Tag? {
    get { self[TagKey.self] }
    set { self[TagKey.self] = newValue }
  }
}

extension View {

  public func tag<Value>(_ value: Value) -> some View
  where Value: Hashable, Value: Sendable {
    environment(\.tag, Tag(tag: value))
  }
}
