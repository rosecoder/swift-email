public struct Font {

    let name: String
    var size: Int
    var weight: Weight
    var isItalic: Bool = false

    public init(name: String, size: Int = 16, weight: Weight = .regular) {
        self.name = name
        self.size = size
        self.weight = weight
    }
}

extension Font: Equatable {}

extension Font: CSSValue {

    public func renderCSSValue(environmentValues: EnvironmentValues) -> String {
        name
    }
}

extension Font {

    public static let system = Font(name: "-apple-system, system-ui, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif")
    public static func system(size: Int, weight: Weight = .regular) -> Font { system.size(size).weight(weight) }

    public static let arial = Font(name: "Arial, sans-serif")
    public static func arial(size: Int, weight: Weight = .regular) -> Font { arial.size(size).weight(weight) }

    public static let courierNew = Font(name: "'Courier New', Courier, monospace")
    public static func courierNew(size: Int, weight: Weight = .regular) -> Font { courierNew.size(size).weight(weight) }

    public static let georgia = Font(name: "Georgia, serif")
    public static func georgia(size: Int, weight: Weight = .regular) -> Font { georgia.size(size).weight(weight) }

    public static let helveticaNeue = Font(name: "'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif")
    public static func helveticaNeue(size: Int, weight: Weight = .regular) -> Font { helveticaNeue.size(size).weight(weight) }

    public static let lucidaSansUnicode = Font(name: "'Lucida Sans Unicode', Lucida, 'Lucida Grande', sans-serif")
    public static func lucidaSansUnicode(size: Int, weight: Weight = .regular) -> Font { lucidaSansUnicode.size(size).weight(weight) }

    public static let tahoma = Font(name: "Tahoma, sans-serif")
    public static func tahoma(size: Int, weight: Weight = .regular) -> Font { tahoma.size(size).weight(weight) }

    public static let timesNewRoman = Font(name: "Times New Roman, Times, serif")
    public static func timesNewRoman(size: Int, weight: Weight = .regular) -> Font { timesNewRoman.size(size).weight(weight) }
}

extension Font {

    public func bold() -> Font {
        var font = self
        font.weight = .bold
        return font
    }

    public func italic() -> Font {
        var font = self
        font.isItalic = true
        return font
    }

    public func weight(_ weight: Weight) -> Font {
        var font = self
        font.weight = weight
        return font
    }

    func size(_ size: Int) -> Font {
        var font = self
        font.size = size
        return font
    }
}
