struct Styles: Sendable {

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

  func renderCSS(environmentValues: EnvironmentValues, isImportant: Bool = false) -> String {
    properties
      .map {
        $0 + ":" + ($1.renderCSSValue(environmentValues: environmentValues))
          + (isImportant ? " !important" : "")
      }
      .sorted()
      .joined(separator: ";")
  }
}

extension Styles: UnsafeNodeAttributesValue {

  func renderValue(environmentValues: EnvironmentValues) -> String {
    renderCSS(environmentValues: environmentValues)
  }
}
