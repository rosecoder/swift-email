import XCTest
import SnapshotTesting
import SwiftEmail

private struct TestKey: EnvironmentKey {

    static var defaultValue = "Hello world!"
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

final class EnvironmentTests: XCTestCase {

    func testEnvironmentDefaultUsage() async throws {
        let view = UsageView()
        let html = await view.renderHTML()
        XCTAssertEqual(html, "Hello world!")
    }

    func testEnvironmentOverrideUsage() async throws {
        let view = UsageView()
            .environment(\.test, "Override!")
        let html = await view.renderHTML()
        XCTAssertEqual(html, "Override!")
    }

    func testEnvironmentOverrideUsageMultipleAsync() async throws {
        await withTaskGroup(of: Void.self) { group in
            for index in 0..<10_000 {
                group.addTask {
                    let view = UsageView()
                        .environment(\.test, "Override \(index)")
                    let html = await view.renderHTML()
                    XCTAssertEqual(html, "Override \(index)")
                }
            }
        }
    }
}
