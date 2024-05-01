import Foundation
import SwiftEmail
import SnapshotTesting

extension Snapshotting where Value: View, Format == String {

    public static var html: Snapshotting {
        html()
    }

    public static func html(
        format: RenderOptions.Format = .pretty,
        indent: String = "  "
    ) -> Snapshotting {
        var snapshotting = SimplySnapshotting.lines.asyncPullback { (view: Value) in
            Async { callback in
                Task {
                    let result = await view.render(options: .init(
                        format: format,
                        indent: indent
                    ))
                    callback(result.html)
                }
            }
        }
        snapshotting.pathExtension = "html"
        return snapshotting
    }
}
