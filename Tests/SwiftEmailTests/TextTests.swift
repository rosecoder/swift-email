import XCTest
import SwiftEmail

final class TextTests: XCTestCase {

    func testRenderHTML() async throws {
        let render = await Text("Hello world!").render()
        XCTAssertEqual(render.html, "Hello world!")
    }

    func testRenderHTMLWithNewline() async throws {
        let render = await Text("Hello\nworld!").render()
        XCTAssertEqual(render.html, "Hello<br/>world!")
        XCTAssertEqual(render.text, "Hello\nworld!")
    }

    func testRenderHTMLEscapeCharacters() async throws {
        do {
            let render = await Text("<script>alert('XSS')</script>").render()
            XCTAssertEqual(
                render.html,
                "&lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;"
            )
        }
        do {
            let render = await Text("<a href='javascript:alert(\"XSS\")'>Click me</a>").render()
            XCTAssertEqual(
                render.html,
                "&lt;a href=&#39;javascript:alert(&quot;XSS&quot;)&#39;&gt;Click me&lt;/a&gt;"
            )
        }
        do {
            let render = await Text("<img src=x onerror=alert('XSS')>").render()
            XCTAssertEqual(
                render.html,
                "&lt;img src=x onerror=alert(&#39;XSS&#39;)&gt;"
            )
        }
        do {
            let render = await Text("<ScRiPt>alert('XSS')</ScRiPt>").render()
            XCTAssertEqual(
                render.html,
                "&lt;ScRiPt&gt;alert(&#39;XSS&#39;)&lt;/ScRiPt&gt;"
            )
        }
    }

    func testFontBold() async throws {
        let render = await Text("Hello world!")
            .font(Font.helveticaNeue.bold())
            .render()
        XCTAssertEqual(render.html, "<b style=\"font-size:16px;font-weight:700;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif\">Hello world!</b>")
    }

    func testFontItalic() async throws {
        let render = await Text("Hello world!")
            .font(Font.helveticaNeue.italic())
            .render()
        XCTAssertEqual(render.html, "<i style=\"font-size:16px;font-weight:400;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif;font-style:italic\">Hello world!</i>")
    }

    func testFontBoldAndItalic() async throws {
        let render = await Text("Hello world!")
            .font(Font.helveticaNeue.bold().italic())
            .render()
        XCTAssertEqual(render.html, "<i><b style=\"font-size:16px;font-weight:700;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif;font-style:italic\">Hello world!</b></i>")
    }

    func testForegroundStyle() async throws {
        let render = await Text("Hello world!")
            .foregroundStyle(Color.red)
            .render()
        XCTAssertEqual(render.html, "<span style=\"color:#f00\">Hello world!</span>")
    }

    func testBackground() async throws {
        let render = await Text("Hello world!")
            .background(Color.blue)
            .render()
        XCTAssertEqual(render.html, "<span style=\"background:#00f\">Hello world!</span>")
    }

    func testBorder() async throws {
        let render = await Text("Hello world!")
            .border(Color.green, width: 4)
            .render()
        XCTAssertEqual(render.html, "<span style=\"border:4px solid #0f0\">Hello world!</span>")
    }

    func testUnderline() async throws {
        let render = await Text("Hello world!")
            .underline()
            .render()
        XCTAssertEqual(render.html, "<span style=\"text-decoration:underline\">Hello world!</span>")
    }
}
