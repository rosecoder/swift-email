import Foundation

public struct EnvironmentValues {

  var overrides = [String: Any]()

  public subscript<K: EnvironmentKey>(key: K.Type) -> K.Value {
    get {
      if let override = overrides[key.rawValue] {
        return override as! K.Value
      }
      return key.defaultValue
    }
    set {
      overrides[key.rawValue] = newValue
    }
  }

  static var `default`: EnvironmentValues { .init() }

  static var current: EnvironmentValues {
    get {
      if let current = Thread.current.threadDictionary["SEEV"] as? EnvironmentValues {
        return current
      }
      print(
        "error: Accessing EnvironmentValues outside of any rendering context. This will result in default values being used."
      )
      return EnvironmentValues()
    }
    set {
      Thread.current.threadDictionary["SEEV"] = newValue
    }
  }
}
