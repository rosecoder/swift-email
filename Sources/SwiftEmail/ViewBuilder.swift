@resultBuilder
public struct ViewBuilder {

    public static func buildBlock() -> EmptyView {
        EmptyView()
    }

    public static func buildBlock<Content: View>(_ content: Content) -> Content {
        content
    }

    public static func buildBlock<each Content>(_ content: repeat each Content) -> TupleView<(repeat each Content)> where repeat each Content: View {
        TupleView(content: repeat each content)
    }

    public static func buildExpression<Content: View>(_ expression: Content) -> Content {
        expression
    }

    public static func buildEither<TrueContent: View, FalseContent: View>(first component: TrueContent) -> ConditionalContent<TrueContent, FalseContent> {
        .first(component)
    }

    public static func buildEither<TrueContent: View, FalseContent: View>(second component: FalseContent) -> ConditionalContent<TrueContent, FalseContent> {
        .second(component)
    }

    public static func buildOptional<Content: View>(_ component: Content?) -> ConditionalContent<Content, EmptyView> {
        if let component {
            return .first(component)
        }
        return .second(EmptyView())
    }

    public static func buildLimitedAvailability<Content: View>(_ component: Content) -> Content {
        component
    }
}

public enum ConditionalContent<TrueContent: View, FalseContent: View>: View {
    case first(TrueContent)
    case second(FalseContent)

    public var body: some View {
        switch self {
        case .first(let view):
            return AnyView(view)
        case .second(let view):
            return AnyView(view)
        }
    }
}
