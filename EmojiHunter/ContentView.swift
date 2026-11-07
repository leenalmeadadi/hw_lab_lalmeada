//
//  ContentView.swift
//  EmojiHunter
//

import SwiftUI

// Main game screen: camera (or NEXT screen) underneath, messages on top
struct ContentView: View {
    @State private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            // Round is over (found or time ran out) -> show the NEXT screen,
            // otherwise show the camera
            if (viewModel.showNext || viewModel.emojiStatus == .found)
                && viewModel.emojiStatus != .gameOver {
                Color.black
                    .ignoresSafeArea()

                Button {
                    viewModel.startSearch()
                } label: {
                    Text("NEXT")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            } else {
                // $ passes a binding so the camera can change emojiStatus to .found
                CustomCameraRepresentable(emojiString: emojiObjects[viewModel.currentLevel].emojiName, emojiFound: $viewModel.emojiStatus)
                    // New id per level makes a fresh camera with the right target (needed after restart)
                    .id(viewModel.currentLevel)
                    .ignoresSafeArea()
            }

            // Bottom messages: game over button, or timer + emoji text
            VStack {
                Spacer()

                if viewModel.emojiStatus == .gameOver {
                    Button {
                        viewModel.restartGame()
                    } label: {
                        Text("GAME OVER\nTap to restart")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 30)
                } else {
                    if viewModel.emojiStatus == .searching {
                        // Countdown; onReceive calls adjustTime every second
                        Text("\(viewModel.timeRemaining)")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                            .onReceive(viewModel.timer) { _ in
                                viewModel.adjustTime()
                            }
                    }

                    viewModel.emojiResultText()
                        .foregroundColor(viewModel.emojiStatus == .notFound ? .red : .white)
                        .padding(.bottom, 30)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
