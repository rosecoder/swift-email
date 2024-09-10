import Testing
import SwiftEmail

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

    @Test func environmentDefaultUsage() async throws {
        let view = UsageView()
        let render = await view.render()
        #expect(render.html == "Hello world!")
        #expect(render.text == "Hello world!")
    }

    func testEnvironmentOverrideUsage() async throws {
        let view = UsageView()
            .environment(\.test, "Override!")
        let render = await view.render()
        #expect(render.html == "Override!")
        #expect(render.text == "Override!")
    }

    func testEnvironmentOverrideUsageMultipleAsync() async throws {
        await withTaskGroup(of: Void.self) { group in
            for index in 0..<10_000 {
                group.addTask {
                    let view = UsageView()
                        .environment(\.test, "Override \(index)")
                    let render = await view.render()
                    #expect(render.html == "Override \(index)")
                    #expect(render.text == "Override \(index)")
                }
            }
        }
    }
}
