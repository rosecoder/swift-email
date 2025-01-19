import Foundation
import Synchronization

final class LocalizedStringsService: Sendable {

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
