struct Styles {

    var properties: [String: CSSValue]

    init(properties: [String: CSSValue] = [:]) {
        self.properties = properties
    }

    var isEmpty: Bool {
        properties.isEmpty
    }

    subscript(key: String) -> CSSValue? {
        get {
            properties[key]
        }
        set {
            properties[key] = newValue
        }
    }

    func renderCSS(environmentValues: EnvironmentValues, isImportant: Bool = false) async -> String {
        await withTaskGroup(of: String.self) { group in
            for (key, value) in properties {
                group.addTask {
                    key + ":" + (await value.renderCSSValue(environmentValues: environmentValues)) + (isImportant ? " !important" : "")
                }
            }

            var outputs = [String]()
            outputs.reserveCapacity(properties.count)
            for await result in group {
                outputs.append(result)
            }
            return outputs.sorted().joined(separator: ";")
        }
    }
}

extension Styles: UnsafeNodeAttributesValue {

    func renderValue(environmentValues: EnvironmentValues) async -> String {
        await renderCSS(environmentValues: environmentValues)
    }
}
