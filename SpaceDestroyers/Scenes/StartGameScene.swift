import SpriteKit

class StartGameScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black

        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        startGameButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        startGameButton.name = "startgame"
        addChild(startGameButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        // only start if they actually tapped the button
        if touchedNode.name == "startgame" {
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameScene, transition: transition)
        }
    }
}
