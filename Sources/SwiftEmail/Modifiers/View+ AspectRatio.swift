private struct ContentModeKey: EnvironmentKey {

  static let defaultValue: ContentMode? = nil
}

extension EnvironmentValues {

  public var contentMode: ContentMode? {
    get { self[ContentModeKey.self] }
    set { self[ContentModeKey.self] = newValue }
  }
}

public enum ContentMode: Sendable {
  case fill
  case fit
}

extension View {

  public func aspectRatio(contentMode: ContentMode) -> some View {
    environment(\.contentMode, contentMode)
  }

  public func scaledToFill() -> some View {
    aspectRatio(contentMode: .fill)
  }

  public func scaledToFit() -> some View {
    aspectRatio(contentMode: .fit)
  }
}
