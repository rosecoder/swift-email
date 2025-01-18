private struct CornerRadiusKey: EnvironmentKey {

  static let defaultValue: Float = 0
}

extension EnvironmentValues {

  public var cornerRadius: Float {
    get { self[CornerRadiusKey.self] }
    set { self[CornerRadiusKey.self] = newValue }
  }
}

extension View {

  public func cornerRadius(_ radius: Float) -> some View {
    environment(\.cornerRadius, radius)
  }

  public func cornerRadius(
    _ radius: Float,
    when userInteraction: UserInteraction,
    file: StaticString = #file,
    line: UInt = #line
  ) -> some View {
    let className = ClassName(uniqueAt: file, line: line)
    return
      self
      .unsafeClass(className)
      .unsafeGlobalStyle(
        "border-radius", String(Int(radius)) + "px",
        selector: .className(className, pseudo: userInteraction.cssPseudo))
  }
}
