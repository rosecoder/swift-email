import Foundation

public struct EnvironmentValues: Sendable {

    var overrides = [String: any Sendable]()

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

    @TaskLocal
    static var current: EnvironmentValues = EnvironmentValues()
}
