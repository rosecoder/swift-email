public struct CSSSelector {

    let target: Target
    let pseudo: CSSPseudo?
    let colorScheme: ColorScheme?

    public static func className(
        _ className: ClassName,
        pseudo: CSSPseudo? = nil,
        colorScheme: ColorScheme? = nil
    ) -> Self {
        self.init(target: .className(className), pseudo: pseudo, colorScheme: colorScheme)
    }

    public static func element(
        _ tag: String,
        pseudo: CSSPseudo? = nil,
        colorScheme: ColorScheme? = nil
    ) -> Self {
        self.init(target: .element(tag), pseudo: pseudo, colorScheme: colorScheme)
    }
}

extension CSSSelector: Hashable {}
extension CSSSelector: Equatable {}

extension CSSSelector: Comparable {

    public static func < (lhs: CSSSelector, rhs: CSSSelector) -> Bool {
        lhs.target < rhs.target
    }
}

extension CSSSelector {

    public enum Target {
        case className(ClassName)
        case element(String)
    }
}

extension CSSSelector.Target: Hashable {}
extension CSSSelector.Target: Equatable {}
extension CSSSelector.Target: Comparable {}

extension CSSSelector {

    func renderCSS(options: HTMLRenderOptions) -> String {
        var output: String
        switch target {
        case .className(let className):
            output = "." + className.renderCSS(options: options)
        case .element(let tag):
            output = tag
        }
        if let pseudo {
            output += ":" + pseudo.renderCSSPseudo()
        }
        return output
    }
}
