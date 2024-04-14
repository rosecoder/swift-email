public protocol View {

    associatedtype Body: View

    @ViewBuilder var body: Body { get async }
}
