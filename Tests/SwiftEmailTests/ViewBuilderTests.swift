import XCTest
import SwiftEmail

final class ViewBuilderTests: XCTestCase {

    struct Root<Content: View>: View {

        let content: Content

        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }

        var body: some View { content }
    }

    func testEmpty() async throws {
        let view = Root {
            // Empty
        }
        let render = await view.render()
        XCTAssertEqual(render.html, "")
    }

    func testSingleView() async throws {
        let view = Root {
            Text("Hello world!")
        }
        let render = await view.render()
        XCTAssertEqual(render.html, "Hello world!")
    }

    func testMultipleView() async throws {
        let view = Root {
            Text("Hello")
            Text(" ")
            Text("world!")
        }
        let render = await view.render()
        XCTAssertEqual(render.html, "Hello world!")
    }

    func testConditionalTrue() async throws {
        let view = Root {
            if "a" == "a" {
                Text("Hello world!")
            }
        }
        let render = await view.render()
        XCTAssertEqual(render.html, "Hello world!")
    }

    func testConditionalFalse() async throws {
        let view = Root {
            if "a" == "b" {
                Text("Hello world!")
            }
        }
        let render = await view.render()
        XCTAssertEqual(render.html, "")
    }

    func testConditionalTrueOrFalse() async throws {
        let view = Root {
            if "a" == "a" {
                Text("Hello")
            } else {
                Text("world!")
            }
        }
        let render = await view.render()
        XCTAssertEqual(render.html, "Hello")
    }

    func testConditionalFalseOrTrue() async throws {
        let view = Root {
            if "a" == "b" {
                Text("Hello")
            } else {
                Text("world!")
            }
        }
        let render = await view.render()
        XCTAssertEqual(render.html, "world!")
    }

    func testLimitedAvailability() async throws {
        let view = Root {
            if #available(macOS 10.0, *) {
                Text("Hello world!")
            }
        }
        let render = await view.render()
        XCTAssertEqual(render.html, "Hello world!")
    }
}
