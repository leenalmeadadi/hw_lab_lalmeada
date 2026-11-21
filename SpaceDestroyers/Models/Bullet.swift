import SpriteKit

// shared stuff for both bullet types, the subclasses set up the physics
class Bullet: SKSpriteNode {
    init(imageName: String, bulletSound: String?) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        // invader bullets pass nil so they don't make a sound
        if let sound = bulletSound {
            run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
        }
    }

    // not using .sks files so this never gets called
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
