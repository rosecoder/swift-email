public protocol UnsafeNodeAttributesValue {

    func renderValue(environmentValues: EnvironmentValues) async -> String
}

extension String: UnsafeNodeAttributesValue {

    public func renderValue(environmentValues: EnvironmentValues) async -> String {
        self
    }
}
