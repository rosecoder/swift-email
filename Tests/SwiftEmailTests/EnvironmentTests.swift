import SwiftEmail
import Testing

private struct TestKey: EnvironmentKey {

  static let defaultValue = "Hello world!"
}

extension EnvironmentValues {

  fileprivate var test: String {
    get { self[TestKey.self] }
    set { self[TestKey.self] = newValue }
  }
}

private struct UsageView: View {

  @Environment(\.test) private var text

  var body: some View {
    Text(text)
  }
}

@Suite
struct EnvironmentTests {

  @Test func environmentDefaultUsage() {
    let view = UsageView()
    let render = view.render()
    #expect(render.html == "Hello world!")
    #expect(render.text == "Hello world!")
  }

  func testEnvironmentOverrideUsage() {
    let view = UsageView()
      .environment(\.test, "Override!")
    let render = view.render()
    #expect(render.html == "Override!")
    #expect(render.text == "Override!")
  }
}
