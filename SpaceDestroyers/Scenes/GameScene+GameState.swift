import SpriteKit

extension GameScene {

    // MARK: - Game State Management

    // Transitions back to the start menu
    func newGame() {
        let startScene = StartGameScene(size: size)
        startScene.scaleMode = scaleMode
        let transition = SKTransition.flipHorizontal(withDuration: Constants.Game.sceneTransitionDuration)
        view?.presentScene(startScene, transition: transition)
    }

    // Advances to next level or restarts the game if we've beaten the last one
    func levelComplete() {
        if !GameStateManager.shared.isMaxLevelReached() {
            let levelCompleteScene = LevelCompleteScene(size: size)
            levelCompleteScene.scaleMode = scaleMode
            let transition = SKTransition.flipHorizontal(withDuration: Constants.Game.sceneTransitionDuration)
            view?.presentScene(levelCompleteScene, transition: transition)
        } else {
            GameStateManager.shared.resetLevel()
            newGame()
        }
    }
}
