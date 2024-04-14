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
}
