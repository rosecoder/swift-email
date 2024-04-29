import Foundation

public struct PlainText: View {

    let value: String

    public init(_ value: String) {
        self.value = value
    }

    public var body: Never { noBody }
}

extension PlainText: PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) -> String {
        context.indentation(options: options) +
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
