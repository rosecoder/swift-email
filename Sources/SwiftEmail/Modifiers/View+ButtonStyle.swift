private struct ButtonStyleKey: EnvironmentKey {

  static let defaultValue: AnyButtonStyle = AnyButtonStyle(LinkButtonStyle())
}

extension EnvironmentValues {

  public var buttonStyle: AnyButtonStyle {
    get { self[ButtonStyleKey.self] }
    set { self[ButtonStyleKey.self] = newValue }
  }
}

extension View {

  public func buttonStyle<Style: ButtonStyle>(_ style: Style) -> some View {
    environment(\.buttonStyle, AnyButtonStyle(style))
  }
}

public protocol ButtonStyle: Sendable {

  typealias Configuration = ButtonStyleConfiguration
  associatedtype Body: View

  @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

public struct ButtonStyleConfiguration {

  public typealias Label = AnyView

  public let label: Label
}

public struct AnyButtonStyle: ButtonStyle {

  let content: any ButtonStyle

  public init(_ content: any ButtonStyle) {
    self.content = content
  }

  public func makeBody(configuration: Configuration) -> some View {
    AnyView(content.makeBody(configuration: configuration))
  }
}
