import Foundation

actor LocalizedStringsService {

    static let shared = LocalizedStringsService()

    private init() {}

    private let defaultLocale = Locale.current

    func translated(key: LocalizedStringKey, bundle: Bundle, locale: Locale) -> String {
        var fallback: String {
            if locale == defaultLocale {
                return key.rawValue
            }
            return translated(key: key, bundle: bundle, locale: defaultLocale)
        }

        guard let strings = getStrings(bundle: bundle, locale: locale) else {
            // TODO: Add logging
            return fallback
        }
        guard let translated = strings[key.rawValue] else {
            // TODO: Add logging
            return fallback
        }
        if key.interpolationValues.isEmpty {
            return translated
        }
        return String(format: translated, arguments: key.interpolationValues)
    }

    private typealias StringsSet = [String: String]
    private var stringsCache = [Locale: StringsSet]()

    private func getStrings(bundle: Bundle, locale: Locale) -> StringsSet? {
        if let cached = stringsCache[locale] {
            return cached
        }
        let set = loadStrings(bundle: bundle, locale: locale)
        if let set {
            stringsCache[locale] = set
        }
        return set
    }

    private nonisolated func loadStrings(bundle: Bundle, locale: Locale) -> StringsSet? {
        guard let path = bundle.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: locale.languageCode) else {
            return nil
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let fileContent = String(decoding: data, as: UTF8.self)
        return Dictionary(uniqueKeysWithValues: fileContent.split(separator: ";").map { line in
            let components = line.split(separator: "=")
            return (
                decodeLocalizableString(component: components.first ?? ""),
                decodeLocalizableString(component: components.last ?? "")
            )
        })
    }

    private nonisolated func decodeLocalizableString(component: Substring.SubSequence) -> String {
        String(component.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst().dropLast())
    }
}
