extension UnsafeNode {

  public struct Attributes: ExpressibleByDictionaryLiteral {

    public typealias Key = String
    public typealias Value = any UnsafeNodeAttributesValue

    var values: [String: any UnsafeNodeAttributesValue]

    public init(dictionaryLiteral elements: (Key, Value)...) {
      self.values = .init(uniqueKeysWithValues: elements)
    }

    func renderHTML(options: RenderOptions, context: RenderContext) -> String {
      if values.isEmpty {
        return ""
      }

      let mapped =
        values
        .map { $0 + "=\"" + ($1.renderValue(environmentValues: context.environmentValues)) + "\"" }

      switch options.format {
      case .compact:
        return " " + mapped.joined(separator: " ")
      case .pretty:
        return " " + mapped.sorted().joined(separator: " ")
      }
    }
  }
}
