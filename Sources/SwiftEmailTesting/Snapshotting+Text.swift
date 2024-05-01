import Foundation
import SwiftEmail
import SnapshotTesting

extension Snapshotting where Value: View, Format == String {

    public static var text: Snapshotting {
        var snapshotting = SimplySnapshotting.lines.asyncPullback { (view: Value) in
            Async { callback in
                Task {
                    let result = await view.render()
                    callback(result.text)
                }
            }
        }
        snapshotting.pathExtension = "txt"
        return snapshotting
    }
}
