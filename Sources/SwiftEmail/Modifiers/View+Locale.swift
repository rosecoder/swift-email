import Foundation

private struct LocaleKey: EnvironmentKey {

  static var defaultValue: Locale {
    .current
  }
}

extension EnvironmentValues {

  public var locale: Locale {
    get { self[LocaleKey.self] }
    set { self[LocaleKey.self] = newValue }
  }
}
