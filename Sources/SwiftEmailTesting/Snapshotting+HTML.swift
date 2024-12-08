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
        var snapshotting = SimplySnapshotting.lines.pullback { (view: Value) in
            view.render(options: RenderOptions(
                format: format,
                indent: indent
            )).html
        }
        snapshotting.pathExtension = "html"
        return snapshotting
    }
}
