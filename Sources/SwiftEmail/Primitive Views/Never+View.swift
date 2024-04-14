extension Never: View {

    public typealias Body = Never

    public var body: Never {
        fatalError()
    }
}
