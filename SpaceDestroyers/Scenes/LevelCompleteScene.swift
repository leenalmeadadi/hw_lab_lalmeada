import SpriteKit

class LevelCompleteScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        let nextLevelButton = SKSpriteNode(imageNamed: "nextlevelbtn")
        nextLevelButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        nextLevelButton.name = "nextlevel"
        addChild(nextLevelButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if touchedNode.name == "nextlevel" {
            // new GameScene picks up the new level from GameStateManager
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameScene, transition: transition)
        }
    }
}
