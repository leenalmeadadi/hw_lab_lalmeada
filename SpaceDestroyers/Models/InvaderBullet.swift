import SpriteKit

// same as PlayerBullet but it's looking for the player instead
class InvaderBullet: Bullet {
    override init(imageName: String, bulletSound: String?) {
        super.init(imageName: imageName, bulletSound: bulletSound)

        guard let texture = self.texture else { return }
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.invaderBullet
        self.physicsBody?.contactTestBitMask = CollisionCategories.player
        self.physicsBody?.collisionBitMask = 0x0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
