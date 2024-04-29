struct Head<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View { noBody }
}

extension Head: PrimitiveView {

    func renderRootHTML(options: HTMLRenderOptions, context: HTMLRenderContext) async -> String {
        let content = await contentWithStyle(options: options, context: context)
        return await content.renderHTML(options: options, context: context)
    }

    @ViewBuilder private func contentWithStyle(options: HTMLRenderOptions, context: HTMLRenderContext) async -> some View {
        UnsafeNode(tag: "head") {
            content
            context.globalStyle
        }
    }
}
