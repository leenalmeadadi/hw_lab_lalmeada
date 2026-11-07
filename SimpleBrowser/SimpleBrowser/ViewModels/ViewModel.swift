import SwiftUI
import Combine

// All the actions the bottom toolbar can ask the web view to perform.
enum WebViewOptions {
    case back
    case forward
    case share
    case refresh
    case stop
}

// Holds the app's shared state and sends toolbar actions to the web view.
class ViewModel: ObservableObject {
    // The URL typed in the search bar (without "https://").
    @Published var urlString: String = ""
    // Controls whether the share sheet is showing.
    @Published var shouldShowShareSheet: Bool = false

    // Publisher that sends toolbar actions to the WebView's Coordinator.
    @Published var webViewOptionsPublisher =
        PassthroughSubject<WebViewOptions, Never>()

    // Each function below sends one action to the web view.

    // Go back to the previous page.
    func goBack() {
        webViewOptionsPublisher.send(.back)
    }

    // Go forward to the next page.
    func goForward() {
        webViewOptionsPublisher.send(.forward)
    }

    // Open the share sheet.
    func share() {
        webViewOptionsPublisher.send(.share)
    }

    // Reload the current page.
    func refresh() {
        webViewOptionsPublisher.send(.refresh)
    }

    // Stop the page from loading.
    func stop() {
        webViewOptionsPublisher.send(.stop)
    }
}
