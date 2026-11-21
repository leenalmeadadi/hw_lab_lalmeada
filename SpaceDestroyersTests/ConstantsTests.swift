import Testing
import CoreGraphics
@testable import SpaceDestroyers

// just checking none of the game values got set to 0 or negative
struct ConstantsTests {

    @Test func maxLevelsIsPositive() {
        #expect(Constants.Game.maxLevels > 0)
    }

    @Test func invaderRowsIsPositive() {
        #expect(Constants.Invader.rows > 0)
    }

    @Test func playerStartsWithLives() {
        #expect(Constants.Player.startingLives > 0)
    }

    @Test func fireRateCooldownIsPositive() {
        #expect(Constants.Player.fireRateCooldown > 0)
    }
}
