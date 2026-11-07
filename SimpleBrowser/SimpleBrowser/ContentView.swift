import SwiftUI

// Main screen: search bar on top, web page in the middle, toolbar at the bottom.
struct ContentView: View {
    // One shared ViewModel passed to every subview so they can communicate.
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            SearchBar(viewModel: viewModel)
            WebView(viewModel: viewModel)
            BottomBar(viewModel: viewModel)
        }
        // Shows the share sheet when shouldShowShareSheet becomes true.
        .sheet(isPresented: $viewModel.shouldShowShareSheet) {
            // Build the full URL of the current page to share.
            if let url = URL(string: "https://\(viewModel.urlString)") {
                ShareSheet(activityItems: [url])
            }
        }
    }
}
