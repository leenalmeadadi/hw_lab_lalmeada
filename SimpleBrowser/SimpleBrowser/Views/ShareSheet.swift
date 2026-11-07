import SwiftUI
import UIKit

// Wraps UIKit's UIActivityViewController so SwiftUI can show the iOS share menu.
struct ShareSheet: UIViewControllerRepresentable {
    // Type of the closure that runs when sharing finishes.
    typealias Callback = (UIActivity.ActivityType?,
                          Bool,
                          [Any]?,
                          Error?) -> Void

    // The items to share (here, the page URL).
    let activityItems: [Any]
    // Optional settings, left as nil to use the defaults.
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil

    // Creates the share controller with the items and settings above.
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }

    // Required by the protocol. Empty because nothing needs updating after it's created.
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}
