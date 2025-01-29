import Foundation
import Logging
import Synchronization

final class LocalizedStringsService: Sendable {

  let logger = Logger(label: "email-localization")

  static let shared = LocalizedStringsService()

  private init() {}

  private let defaultLocale = Locale.current

  func translated(key: LocalizedStringKey, bundle: Bundle, locale: Locale) -> String {
    var fallback: String {
      if locale == defaultLocale {
        return format(translated: key.rawValue, key: key)
      }
      return translated(key: key, bundle: bundle, locale: defaultLocale)
    }

    guard let strings = getStrings(bundle: bundle, locale: locale) else {
      logger.error(
        "Localized strings not found for locale \(locale.identifier) in bundle \(bundle.description) trying to translate key \(key.rawValue)."
      )
      return fallback
    }
    guard let translated = strings[key.rawValue] else {
      logger.error(
        "Localized string not found for key \"\(key.rawValue)\" in bundle \(bundle.description).")
      return fallback
    }
    if key.interpolationValues.isEmpty {
      return translated
    }
    return format(translated: translated, key: key)
  }

  private func format(translated: String, key: LocalizedStringKey) -> String {
    if key.interpolationValues.isEmpty {
      return translated
    }
    return String(format: translated, arguments: key.interpolationValues)
  }

  private struct CacheKey: Hashable {

    let bundle: Bundle
    let locale: Locale
  }

  private typealias StringsSet = [String: String]

  private let stringsCache = Mutex<[CacheKey: StringsSet]>([:])

  private func getStrings(bundle: Bundle, locale: Locale) -> StringsSet? {
    stringsCache.withLock {
      let cacheKey = CacheKey(bundle: bundle, locale: locale)
      if let cached = $0[cacheKey] {
        return cached
      }
      let set = loadStrings(bundle: bundle, locale: locale)
      if let set {
        $0[cacheKey] = set
      }
      return set
    }
  }

  private nonisolated func loadStrings(bundle: Bundle, locale: Locale) -> StringsSet? {
    guard
      let path = bundle.path(
        forResource: "Localizable",
        ofType: "strings",
        inDirectory: nil,
        forLocalization: locale.language.languageCode?.identifier
      )
    else {
      return nil
    }
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
      return nil
    }
    let fileContent = String(decoding: data, as: UTF8.self)
    return Dictionary(
      uniqueKeysWithValues: fileContent.split(separator: ";").map { line in
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
