public protocol UnsafeNodeAttributesValue {

  func renderValue(environmentValues: EnvironmentValues) -> String
}

extension String: UnsafeNodeAttributesValue {

  public func renderValue(environmentValues: EnvironmentValues) -> String {
    self
  }
}
