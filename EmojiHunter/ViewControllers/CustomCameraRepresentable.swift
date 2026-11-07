//
//  CustomCameraRepresentable.swift
//  EmojiHunter
//

import Foundation
import SwiftUI

// Wraps the UIKit CameraViewController so it can be used in SwiftUI
struct CustomCameraRepresentable: UIViewControllerRepresentable {
    var emojiString: String
    @Binding var emojiFound: EmojiSearch

    // Creates the camera controller and sets the coordinator as its delegate
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController(emoji: emojiString)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ cameraViewController: CameraViewController, context: Context) {}

    // The coordinator passes "found" results back to SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(emojiFound: $emojiFound)
    }
}
