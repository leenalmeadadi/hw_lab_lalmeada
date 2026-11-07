//
//  Emoji.swift
//  EmojiHunter
//

import Foundation

// Lets the camera tell another object when the emoji is found.
// AnyObject makes it class-only so the delegate can be weak (no retain cycle).
protocol EmojiFoundDelegate: AnyObject {
    func emojiWasFound(result: Bool)
}

// The possible states of a round
enum EmojiSearch {
    case found
    case notFound
    case searching
    case gameOver
}

// One emoji to hunt for. emojiName must match part of a MobileNetV2 label.
struct EmojiModel: Identifiable {
    let id = UUID()
    var emoji: String
    var emojiName: String
}

// List of emojis played in order
let emojiObjects: [EmojiModel] = [
    EmojiModel(emoji: "💻", emojiName: "laptop"),
    EmojiModel(emoji: "☕️", emojiName: "mug"),
    EmojiModel(emoji: "✍️", emojiName: "pen"),
    EmojiModel(emoji: "⌨️", emojiName: "keyboard"),
    EmojiModel(emoji: "✂️", emojiName: "scissors"),
    EmojiModel(emoji: "🖱️", emojiName: "mouse")
]
