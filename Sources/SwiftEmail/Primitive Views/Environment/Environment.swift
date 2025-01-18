@propertyWrapper public struct Environment<Value> {

  let keyPath: KeyPath<EnvironmentValues, Value>

  public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
    self.keyPath = keyPath
  }

  public var wrappedValue: Value {
    EnvironmentValues.current[keyPath: keyPath]
  }
}
