public protocol CSSValue {

    func renderCSSValue(environmentValues: EnvironmentValues) async -> String
}

extension String: CSSValue {

    public func renderCSSValue(environmentValues: EnvironmentValues) async -> String {
        self
    }
}

extension Float: CSSValue {

    public func renderCSSValue(environmentValues: EnvironmentValues) async -> String {
        String(Int(self)) + "px"
    }
}

extension Int: CSSValue {

    public func renderCSSValue(environmentValues: EnvironmentValues) async -> String {
        String(self) + "px"
    }
}
