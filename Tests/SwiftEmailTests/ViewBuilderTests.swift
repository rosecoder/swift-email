import SwiftEmail
import Testing

@Suite
struct ViewBuilderTests {

  struct Root<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
      self.content = content()
    }

    var body: some View { content }
  }

  @Test func empty() {
    let view = Root {
      // Empty
    }
    let render = view.render()
    #expect(render.html == "")
  }

  @Test func singleView() {
    let view = Root {
      Text("Hello world!")
    }
    let render = view.render()
    #expect(render.html == "Hello world!")
  }

  @Test func multipleView() {
    let view = Root {
      Text("Hello")
      Text(" ")
      Text("world!")
    }
    let render = view.render()
    #expect(render.html == "Hello world!")
  }

  @Test func conditionalTrue() {
    let view = Root {
      if "a" == "a" {
        Text("Hello world!")
      }
    }
    let render = view.render()
    #expect(render.html == "Hello world!")
  }

  @Test func conditionalFalse() {
    let view = Root {
      if "a" == "b" {
        Text("Hello world!")
      }
    }
    let render = view.render()
    #expect(render.html == "")
  }

  @Test func conditionalTrueOrFalse() {
    let view = Root {
      if "a" == "a" {
        Text("Hello")
      } else {
        Text("world!")
      }
    }
    let render = view.render()
    #expect(render.html == "Hello")
  }

  @Test func conditionalFalseOrTrue() {
    let view = Root {
      if "a" == "b" {
        Text("Hello")
      } else {
        Text("world!")
      }
    }
    let render = view.render()
    #expect(render.html == "world!")
  }

  @Test func limitedAvailability() {
    let view = Root {
      if #available(macOS 10.0, *) {
        Text("Hello world!")
      }
    }
    let render = view.render()
    #expect(render.html == "Hello world!")
  }
}
