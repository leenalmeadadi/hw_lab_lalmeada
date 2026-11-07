import WebKit
import Combine
import SwiftUI

// Wraps WebKit's WKWebView so it can be used in SwiftUI.
struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: ViewModel

    // Creates the web view once and sets the Coordinator as its navigation delegate.
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    // Runs when urlString changes: adds "https://" and loads the page.
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: "https://\(viewModel.urlString)") {
            webView.load(URLRequest(url: url))
        }
    }

    // Creates the Coordinator that handles web view events.
    func makeCoordinator() -> Coordinator {
        Coordinator(webView: self)
    }

    // Handles navigation events and listens for toolbar actions from the ViewModel.
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        // Keeps the Combine subscription alive.
        var webViewOptionsSubscriber: AnyCancellable?

        init(webView: WebView) {
            self.parent = webView
        }

        // Cancel the subscription when the Coordinator is destroyed.
        deinit {
            webViewOptionsSubscriber?.cancel()
        }

        // Called when a page starts loading. Subscribes to toolbar actions
        // and performs the matching action on the web view.
        func webView(
            _ webView: WKWebView,
            didStartProvisionalNavigation navigation: WKNavigation!
        ) {
            webViewOptionsSubscriber =
                parent.viewModel.webViewOptionsPublisher.sink(
                    receiveValue: { webViewOption in

                        switch webViewOption {
                        // Go back only if there is a previous page.
                        case .back:
                            if webView.canGoBack {
                                webView.goBack()
                            }

                        // Go forward only if there is a next page.
                        case .forward:
                            if webView.canGoForward {
                                webView.goForward()
                            }

                        // Show the share sheet.
                        case .share:
                            self.parent.viewModel.shouldShowShareSheet = true

                        // Reload the current page.
                        case .refresh:
                            webView.reload()

                        // Stop the page from loading.
                        case .stop:
                            webView.stopLoading()
                        }
                    }
                )
        }
    }
}
