import Testing
import SwiftEmail

@Suite
struct ViewBuilderTests {

    struct Root<Content: View>: View {

        let content: Content

        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }

        var body: some View { content }
    }

    @Test func empty() async throws {
        let view = Root {
            // Empty
        }
        let render = await view.render()
        #expect(render.html == "")
    }

    @Test func singleView() async throws {
        let view = Root {
            Text("Hello world!")
        }
        let render = await view.render()
        #expect(render.html == "Hello world!")
    }

    @Test func multipleView() async throws {
        let view = Root {
            Text("Hello")
            Text(" ")
            Text("world!")
        }
        let render = await view.render()
        #expect(render.html == "Hello world!")
    }

    @Test func conditionalTrue() async throws {
        let view = Root {
            if "a" == "a" {
                Text("Hello world!")
            }
        }
        let render = await view.render()
        #expect(render.html == "Hello world!")
    }

    @Test func conditionalFalse() async throws {
        let view = Root {
            if "a" == "b" {
                Text("Hello world!")
            }
        }
        let render = await view.render()
        #expect(render.html == "")
    }

    @Test func conditionalTrueOrFalse() async throws {
        let view = Root {
            if "a" == "a" {
                Text("Hello")
            } else {
                Text("world!")
            }
        }
        let render = await view.render()
        #expect(render.html == "Hello")
    }

    @Test func conditionalFalseOrTrue() async throws {
        let view = Root {
            if "a" == "b" {
                Text("Hello")
            } else {
                Text("world!")
            }
        }
        let render = await view.render()
        #expect(render.html == "world!")
    }

    @Test func limitedAvailability() async throws {
        let view = Root {
            if #available(macOS 10.0, *) {
                Text("Hello world!")
            }
        }
        let render = await view.render()
        #expect(render.html == "Hello world!")
    }
}
