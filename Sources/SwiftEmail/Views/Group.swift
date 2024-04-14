public struct Group<Content: View>: View {

    public let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        let children: [AnyView] = (content as? ParentableView)?.children ?? [AnyView(content)]

        ForEach(children) { child in
            child
        }
    }
}
