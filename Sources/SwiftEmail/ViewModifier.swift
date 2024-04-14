public protocol ViewModifier {

    typealias Content = AnyView
    associatedtype Body: View

    @ViewBuilder func body(content: Content) -> Body
}

extension View {

    public func modifier<Modifier: ViewModifier>(_ modifier: Modifier) -> ModifiedContent<Self, Modifier> {
        ModifiedContent(content: self, modifier: modifier)
    }
}

public struct ModifiedContent<Content: View, Modifier: ViewModifier>: View {

    fileprivate let content: Content
    fileprivate let modifier: Modifier

    public var body: some View {
        modifier.body(content: AnyView(content))
    }
}
