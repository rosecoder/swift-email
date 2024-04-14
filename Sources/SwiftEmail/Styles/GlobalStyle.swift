public actor GlobalStyle {

    var selectors: [CSSSelector: Styles] = [:]

    func insert(key: String, value: CSSValue, selector: CSSSelector) {
        if var values = selectors[selector] {
            values[key] = value
            selectors[selector] = values
        } else {
            selectors[selector] = Styles(properties: [key: value])
        }
    }
}
