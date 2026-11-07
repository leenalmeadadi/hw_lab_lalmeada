import SwiftUI

// Text field where the user types a URL. Bound to viewModel.urlString.
struct SearchBar: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            Text("URL:")
            TextField("URL", text: $viewModel.urlString)
                // URL keyboard, and no auto-capitalizing or autocorrect so the URL isn't changed.
                .keyboardType(.URL)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}
