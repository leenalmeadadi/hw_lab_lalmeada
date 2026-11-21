import SpriteKit

extension GameScene {

    // MARK: - Input Handling

    // Applies accelerometer-based velocity to the player
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(
            dx: accelerationX * Constants.Input.accelerometerVelocityMultiplier,
            dy: 0
        )
    }

    // Fires a bullet when the screen is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.fireBullet(scene: self)
    }

    // Called before each frame - updates invader positions
    override func update(_ currentTime: TimeInterval) {
        moveInvaders()
    }
}
