extension UnsafeNode {

    public struct Attributes: ExpressibleByDictionaryLiteral {

        public typealias Key = String
        public typealias Value = any UnsafeNodeAttributesValue

        var values: [String: any UnsafeNodeAttributesValue]

        public init(dictionaryLiteral elements: (Key, Value)...) {
            self.values = .init(uniqueKeysWithValues: elements)
        }

        func renderHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
            if values.isEmpty {
                return ""
            }

            return await withTaskGroup(of: String.self) { group in
                for (key, value) in values {
                    group.addTask {
                        key + "=\"" + (await value.renderValue(environmentValues: context.environmentValues)) + "\""
                    }
                }

                var outputs = [String]()
                outputs.reserveCapacity(values.count)
                for await result in group {
                    outputs.append(result)
                }
                switch options.format {
                case .compact:
                    return " " + outputs.joined(separator: " ")
                case .pretty:
                    return " " + outputs.sorted().joined(separator: " ")
                }
            }
        }
    }
}
