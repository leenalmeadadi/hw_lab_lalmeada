import SpriteKit

class PlayerBullet: Bullet {
    override init(imageName: String, bulletSound: String?) {
        super.init(imageName: imageName, bulletSound: bulletSound)

        guard let texture = self.texture else { return }
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.playerBullet
        // want to know when it hits an invader
        self.physicsBody?.contactTestBitMask = CollisionCategories.invader
        // 0 so it doesn't bounce off, we just remove it on contact
        self.physicsBody?.collisionBitMask = 0x0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
