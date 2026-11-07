//
//  Coordinator.swift
//  EmojiHunter
//

import Foundation
import SwiftUI

// Receives the camera's "found" callback and updates the game status through a binding
class Coordinator: NSObject, EmojiFoundDelegate {
    @Binding var emojiFound: EmojiSearch

    init(emojiFound: Binding<EmojiSearch>) {
        _emojiFound = emojiFound
    }

    // Called when the camera recognizes the target object
    func emojiWasFound(result: Bool) {
        print("emojiWasFound \(result)")
        emojiFound = .found
    }
}
