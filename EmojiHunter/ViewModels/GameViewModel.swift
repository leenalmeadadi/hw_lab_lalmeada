//
//  GameViewModel.swift
//  EmojiHunter
//

import SwiftUI
import Observation

// Holds the game state (level, timer, status) and the game logic
@Observable
class GameViewModel {

    // MARK: - Properties setup
    static let roundDuration = 10

    var currentLevel = 0
    var showNext = false

    // Set up timer for the game
    @ObservationIgnored
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var timeRemaining = roundDuration

    // Set initial emoji status to searching
    var emojiStatus = EmojiSearch.searching

    // MARK: - Timer methods

    func instantiateTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    func cancelTimer() {
        self.timer.upstream.connect().cancel()
    }

    // Runs every second: stops the timer if found, otherwise counts down,
    // and marks the round NOT FOUND when time runs out
    func adjustTime() {
        if self.emojiStatus == .found {
            self.cancelTimer()
            self.timeRemaining = Self.roundDuration
        }
        else {
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            else {
                self.emojiStatus = .notFound
                self.showNext = true
            }
        }
    }

    // MARK: - Gameplay methods

    // Goes to the next emoji, or ends the game after the last one
    func startSearch() {
        if self.currentLevel == emojiObjects.count - 1 {
            self.emojiStatus = .gameOver
        }
        else {
            self.currentLevel = self.currentLevel + 1
            startRound()
        }
    }

    func restartGame() {
        self.currentLevel = 0
        startRound()
    }

    // Resets the timer and status for a new round
    func startRound() {
        self.timeRemaining = Self.roundDuration
        self.emojiStatus = .searching
        self.showNext = false
        self.instantiateTimer()
    }

    // Text at the bottom of the screen: the emoji, "is FOUND", or "NOT FOUND"
    func emojiResultText() -> Text {
        switch emojiStatus {
        case .found:
            return Text("\(emojiObjects[currentLevel].emoji) is FOUND")
                .font(.system(size: 50, design: .rounded))
                .fontWeight(.bold)
        case .notFound:
            return Text("\(emojiObjects[currentLevel].emoji) NOT FOUND")
                .font(.system(size: 50, design: .rounded))
                .foregroundColor(.red)
                .fontWeight(.bold)
        default:
            return Text(emojiObjects[currentLevel].emoji)
                .font(.system(size: 50, design: .rounded))
                .fontWeight(.bold)
        }
    }
}
