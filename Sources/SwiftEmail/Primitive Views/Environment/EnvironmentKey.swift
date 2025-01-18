public protocol EnvironmentKey {

  associatedtype Value

  static var defaultValue: Value { get }
}

extension EnvironmentKey {

  static var rawValue: String {
    String(describing: self)
  }
}
