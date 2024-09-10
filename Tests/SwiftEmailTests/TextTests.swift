import Testing
import SwiftEmail

@Suite
struct TextTests {

    @Test func renderHTML() async throws {
        let render = await Text("Hello world!").render()
        #expect(render.html == "Hello world!")
    }

    @Test func renderHTMLWithNewline() async throws {
        let render = await Text("Hello\nworld!").render()
        #expect(render.html == "Hello<br/>world!")
        #expect(render.text == "Hello\nworld!")
    }

    @Test func renderHTMLEscapeCharacters() async throws {
        do {
            let render = await Text("<script>alert('XSS')</script>").render()
            #expect(
                render.html ==
                "&lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;"
            )
        }
        do {
            let render = await Text("<a href='javascript:alert(\"XSS\")'>Click me</a>").render()
            #expect(
                render.html ==
                "&lt;a href=&#39;javascript:alert(&quot;XSS&quot;)&#39;&gt;Click me&lt;/a&gt;"
            )
        }
        do {
            let render = await Text("<img src=x onerror=alert('XSS')>").render()
            #expect(
                render.html ==
                "&lt;img src=x onerror=alert(&#39;XSS&#39;)&gt;"
            )
        }
        do {
            let render = await Text("<ScRiPt>alert('XSS')</ScRiPt>").render()
            #expect(
                render.html ==
                "&lt;ScRiPt&gt;alert(&#39;XSS&#39;)&lt;/ScRiPt&gt;"
            )
        }
    }

    @Test func fontBold() async throws {
        let render = await Text("Hello world!")
            .font(Font.helveticaNeue.bold())
            .render()
        #expect(render.html == "<b style=\"font-size:16px;font-weight:700;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif\">Hello world!</b>")
    }

    @Test func fontItalic() async throws {
        let render = await Text("Hello world!")
            .font(Font.helveticaNeue.italic())
            .render()
        #expect(render.html == "<i style=\"font-size:16px;font-weight:400;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif;font-style:italic\">Hello world!</i>")
    }

    @Test func fontBoldAndItalic() async throws {
        let render = await Text("Hello world!")
            .font(Font.helveticaNeue.bold().italic())
            .render()
        #expect(render.html == "<i><b style=\"font-size:16px;font-weight:700;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif;font-style:italic\">Hello world!</b></i>")
    }

    @Test func foregroundStyle() async throws {
        let render = await Text("Hello world!")
            .foregroundStyle(Color.red)
            .render()
        #expect(render.html == "<span style=\"color:#f00\">Hello world!</span>")
    }

    @Test func background() async throws {
        let render = await Text("Hello world!")
            .background(Color.blue)
            .render()
        #expect(render.html == "<span style=\"background:#00f\">Hello world!</span>")
    }

    @Test func border() async throws {
        let render = await Text("Hello world!")
            .border(Color.green, width: 4)
            .render()
        #expect(render.html == "<span style=\"border:4px solid #0f0\">Hello world!</span>")
    }

    @Test func underline() async throws {
        let render = await Text("Hello world!")
            .underline()
            .render()
        #expect(render.html == "<span style=\"text-decoration:underline\">Hello world!</span>")
    }
}
