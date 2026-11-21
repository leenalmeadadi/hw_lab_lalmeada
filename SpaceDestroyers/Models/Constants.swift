import CoreGraphics

// all the game numbers in one place so i can change difficulty without digging through files
struct Constants {

    // MARK: - Game Settings
    struct Game {
        static let maxLevels = 3
        static let sceneTransitionDuration = 0.5
    }

    // MARK: - Invader Settings
    struct Invader {
        static let rows = 4
        static let initialSpeed = 2
        static let widthMultiplier: CGFloat = 3.0
        static let horizontalSpacing: CGFloat = 10
        static let verticalSpacing: CGFloat = 46
        static let dropDistance: CGFloat = 46 // how far down they go when they hit a wall
        static let fireInterval = 1.5
        static let bulletDuration = 2.0
        static let invadersPerLevelMultiplier = 2
        static let invadersPerLevelBase = 1
        static let imageTypeRange = 1...3 // invader1, invader2, invader3
    }

    // MARK: - Player Settings
    struct Player {
        static let startingLives = 3
        static let bottomOffset: CGFloat = 10
        static let animationFrameCount = 2
        static let animationTimePerFrame = 0.1
        static let fadeOutDuration = 0.4
        static let fadeInDuration = 0.4
        static let respawnBlinkCount = 5
        static let bulletDuration = 1.0
        static let fireRateCooldown = 0.5 // lower = shoot faster
    }

    // MARK: - Input Settings
    struct Input {
        static let accelerometerUpdateInterval = 0.2
        static let accelerometerVelocityMultiplier: CGFloat = 600
    }

    // MARK: - Layout Settings
    struct Layout {
        static let leftBounds: CGFloat = 30
        static let rightBounds: CGFloat = 500
    }
}
