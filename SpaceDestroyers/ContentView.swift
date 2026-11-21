import SwiftUI
import SpriteKit

// SpriteView lets us show the SpriteKit scene in SwiftUI, no view controller needed
struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            SpriteView(scene: makeScene(size: geometry.size))
                .ignoresSafeArea()
        }
    }

    private func makeScene(size: CGSize) -> SKScene {
        let scene = StartGameScene(size: size)
        scene.scaleMode = .aspectFill
        return scene
    }
}
