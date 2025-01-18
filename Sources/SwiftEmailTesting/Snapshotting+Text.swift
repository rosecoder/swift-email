import Foundation
import SnapshotTesting
import SwiftEmail

extension Snapshotting where Value: View, Format == String {

  public static var text: Snapshotting {
    var snapshotting = SimplySnapshotting.lines.pullback { (view: Value) in
      view.render().text
    }
    snapshotting.pathExtension = "txt"
    return snapshotting
  }
}
