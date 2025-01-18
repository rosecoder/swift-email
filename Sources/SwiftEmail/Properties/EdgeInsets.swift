public struct EdgeInsets {

  public var top: Float
  public var bottom: Float
  public var leading: Float
  public var trailing: Float

  public init() {
    self.top = 0
    self.bottom = 0
    self.leading = 0
    self.trailing = 0
  }

  public init(top: Float, bottom: Float, leading: Float, trailing: Float) {
    self.top = top
    self.bottom = bottom
    self.leading = leading
    self.trailing = trailing
  }
}

extension EdgeInsets {

  init(
    edges: Edge.Set,
    length: Float
  ) {
    var insets = EdgeInsets()
    if edges.values.contains(.top) {
      insets.top = length
    }
    if edges.values.contains(.bottom) {
      insets.bottom = length
    }
    if edges.values.contains(.leading) {
      insets.leading = length
    }
    if edges.values.contains(.trailing) {
      insets.trailing = length
    }
    self = insets
  }

}

extension EdgeInsets {

  static func + (lhs: EdgeInsets, rhs: EdgeInsets) -> EdgeInsets {
    var result = lhs
    result.top += rhs.top
    result.bottom += rhs.bottom
    result.leading += rhs.leading
    result.trailing += rhs.trailing
    return result
  }
}
