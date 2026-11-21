import Foundation

// singleton so the level number doesn't reset when we switch scenes
class GameStateManager {

    // MARK: - Singleton
    static let shared = GameStateManager()

    private init() {
        // Private initializer enforces singleton pattern
    }

    // MARK: - Game State
    // can read it from anywhere but only change it through the methods below
    private(set) var currentLevel: Int = 1

    // MARK: - Public Methods
    func advanceToNextLevel() {
        currentLevel += 1
    }

    func resetLevel() {
        currentLevel = 1
    }

    func isMaxLevelReached() -> Bool {
        currentLevel > Constants.Game.maxLevels
    }
}
