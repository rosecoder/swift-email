import XCTest
import SwiftEmail

final class TextTests: XCTestCase {

    func testRenderHTML() async throws {
        let html = await Text("Hello world!").renderHTML()
        XCTAssertEqual(html, "Hello world!")
    }

    func testRenderHTMLEscapeCharacters() async throws {
        do {
            let html = await Text("<script>alert('XSS')</script>").renderHTML()
            XCTAssertEqual(
                html,
                "&lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;"
            )
        }
        do {
            let html = await Text("<a href='javascript:alert(\"XSS\")'>Click me</a>").renderHTML()
            XCTAssertEqual(
                html,
                "&lt;a href=&#39;javascript:alert(&quot;XSS&quot;)&#39;&gt;Click me&lt;/a&gt;"
            )
        }
        do {
            let html = await Text("<img src=x onerror=alert('XSS')>").renderHTML()
            XCTAssertEqual(
                html,
                "&lt;img src=x onerror=alert(&#39;XSS&#39;)&gt;"
            )
        }
        do {
            let html = await Text("<ScRiPt>alert('XSS')</ScRiPt>").renderHTML()
            XCTAssertEqual(
                html,
                "&lt;ScRiPt&gt;alert(&#39;XSS&#39;)&lt;/ScRiPt&gt;"
            )
        }
    }

    func testFontBold() async throws {
        let html = await Text("Hello world!")
            .font(Font.helveticaNeue.bold())
            .renderHTML()
        XCTAssertEqual(html, "<b style=\"font-size:16px;font-weight:700;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif\">Hello world!</b>")
    }

    func testFontItalic() async throws {
        let html = await Text("Hello world!")
            .font(Font.helveticaNeue.italic())
            .renderHTML()
        XCTAssertEqual(html, "<i style=\"font-size:16px;font-weight:400;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif;font-style:italic\">Hello world!</i>")
    }

    func testFontBoldAndItalic() async throws {
        let html = await Text("Hello world!")
            .font(Font.helveticaNeue.bold().italic())
            .renderHTML()
        XCTAssertEqual(html, "<i><b style=\"font-size:16px;font-weight:700;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif;font-style:italic\">Hello world!</b></i>")
    }

    func testForegroundStyle() async throws {
        let html = await Text("Hello world!")
            .foregroundStyle(Color.red)
            .renderHTML()
        XCTAssertEqual(html, "<span style=\"color:#f00\">Hello world!</span>")
    }

    func testBackground() async throws {
        let html = await Text("Hello world!")
            .background(Color.blue)
            .renderHTML()
        XCTAssertEqual(html, "<span style=\"background:#00f\">Hello world!</span>")
    }

    func testBorder() async throws {
        let html = await Text("Hello world!")
            .border(Color.green, width: 4)
            .renderHTML()
        XCTAssertEqual(html, "<span style=\"border:4px solid #0f0\">Hello world!</span>")
    }
}
