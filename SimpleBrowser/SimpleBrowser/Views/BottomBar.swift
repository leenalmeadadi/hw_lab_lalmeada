import SwiftUI

// Bottom toolbar. Each button calls a ViewModel function that tells the web view what to do.
struct BottomBar: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            // Back button
            Button(action: { viewModel.goBack() }) {
                Image(systemName: "chevron.left")
            }

            Spacer()

            // Forward button
            Button(action: { viewModel.goForward() }) {
                Image(systemName: "chevron.right")
            }

            Spacer()

            // Share button
            Button(action: { viewModel.share() }) {
                Image(systemName: "square.and.arrow.up")
            }

            Spacer()

            // Refresh button
            Button(action: { viewModel.refresh() }) {
                Image(systemName: "arrow.clockwise")
            }

            Spacer()

            // Stop loading button
            Button(action: { viewModel.stop() }) {
                Image(systemName: "xmark")
            }
        }
        .padding(.horizontal, 24) 
    }
}
