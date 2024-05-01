import Crypto
import Foundation

public enum ClassName {
    case constant(String)
    case unique(file: String, line: UInt)

    init(_ rawValue: String) {
        self = .constant(rawValue)
    }

    init(uniqueAt file: StaticString, line: UInt) {
        self = .unique(file: String(describing: file), line: line)
    }
}

extension ClassName: Hashable {}
extension ClassName: Equatable {}
extension ClassName: Comparable {}

extension ClassName: ExpressibleByStringLiteral {

    public init(stringLiteral value: StaticString) {
        self.init(String(describing: value))
    }
}

extension ClassName: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .constant(let constant):
            return "\"\(constant)\""
        case .unique:
            return renderCSS(options: .init(format: .pretty))
        }
    }
}

extension ClassName: UnsafeNodeAttributesValue {

    public func renderValue(environmentValues: EnvironmentValues) async -> String {
        renderCSS(options: RenderOptions()) // TODO: Pass correct render options
    }
}

extension ClassName {

    func renderCSS(options: RenderOptions) -> String {
        switch self {
        case .constant(let rawValue):
            return rawValue
        case .unique(let file, let line):
            switch options.format {
            case .compact:
                let digest = Insecure.MD5.hash(data: Data((file + String(line)).utf8))
                var result = digest.map { String(format: "%02hhx", $0) }.joined()
                if CharacterSet.decimalDigits.contains(result.unicodeScalars.first!) {
                    result = "c" + result
                }
                return String(result[..<result.index(result.startIndex, offsetBy: 6)])
            case .pretty:
                let fileName: String
                if let lastPathComponentStart = file.lastIndex(of: "/") {
                    if let pathExtensionStart = file.lastIndex(of: ".") {
                        fileName = String(file[file.index(lastPathComponentStart, offsetBy: 1)..<pathExtensionStart])
                    } else {
                        fileName = String(file[lastPathComponentStart...])
                    }
                } else {
                    fileName = file
                }
                return fileName + "_" + String(line)
            }
        }
    }
}
