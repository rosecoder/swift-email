import Foundation

public struct LocalizedStringKey {

    let rawValue: String
    let interpolationValues: [String]

    public init(_ rawValue: String) {
        self.rawValue = rawValue
        self.interpolationValues = []
    }
}

extension LocalizedStringKey: Sendable {}

extension LocalizedStringKey: Hashable {}

extension LocalizedStringKey: Equatable {}

extension LocalizedStringKey: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.rawValue = value
        self.interpolationValues = []
    }
}

extension LocalizedStringKey: ExpressibleByStringInterpolation {

    public init(stringInterpolation: StringInterpolation) {
        self.rawValue = stringInterpolation.key
        self.interpolationValues = stringInterpolation.interpolationValues
    }

    public struct StringInterpolation: StringInterpolationProtocol {
        
        public typealias StringLiteralType = String

        var key: String
        var interpolationValues: [String]

        public init(literalCapacity: Int, interpolationCount: Int) {
            self.key = ""
            self.key.reserveCapacity(literalCapacity + interpolationCount * 2)

            self.interpolationValues = []
            self.interpolationValues.reserveCapacity(interpolationCount)
        }

        public mutating func appendLiteral(_ literal: String) {
            key += literal
        }

        public mutating func appendInterpolation(_ string: String) {
            key += "%@"
            interpolationValues.append(string)
        }

        public mutating func appendInterpolation<Subject: NSObject>(_ subject: Subject, formatter: Formatter? = nil) {
            key += "%@"
            interpolationValues.append(formatter?.string(for: subject) ?? subject.description)
        }
    }
}
