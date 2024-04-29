public struct LinkButtonStyle: ButtonStyle {

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label // underline is added through NavigationLink directly
    }
}
