import SpriteKit

extension GameScene {

    // MARK: - Invader Management

    // Moves invaders horizontally and drops them down when reaching screen edges
    func moveInvaders() {
        var changeDirection = false

        enumerateChildNodes(withName: "invader") { node, _ in
            guard let invader = node as? SKSpriteNode else { return }
            let invaderHalfWidth = Constants.Invader.widthMultiplier * invader.size.width/2
            invader.position.x -= CGFloat(self.invaderSpeed)

            if invader.position.x > self.size.width - invaderHalfWidth
                || invader.position.x < self.leftBounds + invaderHalfWidth {
                changeDirection = true
            }
        }

        // if any of them hit the edge, flip direction and move all of them down
        if changeDirection {
            self.invaderSpeed *= -1
            self.enumerateChildNodes(withName: "invader") { node, _ in
                guard let invader = node as? SKSpriteNode else { return }
                invader.position.y -= Constants.Invader.dropDistance
            }
        }
    }

    // Sets up a repeating action for invaders to fire at regular intervals
    func invokeInvaderFire() {
        let fireBullet = SKAction.run { self.fireInvaderBullet() }
        let waitToFireInvaderBullet = SKAction.wait(forDuration: Constants.Invader.fireInterval)
        let invaderFire = SKAction.sequence([fireBullet, waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatForever(invaderFire)
        run(repeatForeverAction)
    }

    // Picks a random invader to fire, or advances the level if all invaders are dead
    func fireInvaderBullet() {
        if invadersWhoCanFire.isEmpty {
            GameStateManager.shared.advanceToNextLevel()
            levelComplete()
        } else if let randomInvader = invadersWhoCanFire.randomElement() {
            randomInvader.fireBullet(scene: self)
        }
    }
}
