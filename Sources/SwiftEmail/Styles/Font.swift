public struct Font {

    let name: String
    var size: Int = 16
    var weight: Weight = .regular
    var isItalic: Bool = false

    init(name: String) {
        self.name = name
    }
}

extension Font: Equatable {}

extension Font: CSSValue {

    public func renderCSSValue(environmentValues: EnvironmentValues) async -> String {
        name
    }
}

extension Font {

    public static let system = Font(name: "-apple-system, system-ui, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif")
    public static let arial = Font(name: "Arial, sans-serif")
    public static let courierNew = Font(name: "'Courier New', Courier, monospace")
    public static let georgia = Font(name: "Georgia, serif")
    public static let helveticaNeue = Font(name: "'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif")
    public static let lucidaSansUnicode = Font(name: "'Lucida Sans Unicode', Lucida, 'Lucida Grande', sans-serif")
    public static let tahoma = Font(name: "Tahoma, sans-serif")
    public static let timesNewRoman = Font(name: "Times New Roman, Times, serif")
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
}
