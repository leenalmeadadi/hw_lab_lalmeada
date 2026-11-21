import SpriteKit

extension GameScene {

    // MARK: - Collision Handling

    func didBegin(_ contact: SKPhysicsContact) {

        // Ensure firstBody has the lower categoryBitMask so we can test in order
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        // Invader hit by player bullet
        if (firstBody.categoryBitMask & CollisionCategories.invader != 0)
            && (secondBody.categoryBitMask & CollisionCategories.playerBullet != 0) {
            // parent checks stop a crash if 2 bullets hit the same invader at once
            guard let invader = firstBody.node as? Invader,
                  let bullet = secondBody.node,
                  invader.parent != nil,
                  bullet.parent != nil else {
                return
            }
            handleInvaderHit(invader: invader, bullet: bullet)
        }

        // Player hit by invader bullet
        if (firstBody.categoryBitMask & CollisionCategories.player != 0)
            && (secondBody.categoryBitMask & CollisionCategories.invaderBullet != 0) {
            player.die()
        }

        // Player collides directly with an invader
        if (firstBody.categoryBitMask & CollisionCategories.invader != 0)
            && (secondBody.categoryBitMask & CollisionCategories.player != 0) {
            player.kill()
        }
    }

    // MARK: - Helper Methods

    // Handles invader destruction: promotes the invader above, then removes both nodes
    private func handleInvaderHit(invader: Invader, bullet: SKNode) {
        let newInvaderRow = invader.invaderRow - 1
        let newInvaderColumn = invader.invaderColumn

        // Enable the invader above (if any) to fire
        if newInvaderRow >= 1 {
            self.enumerateChildNodes(withName: "invader") { node, _ in
                guard let invader = node as? Invader else { return }
                if invader.invaderRow == newInvaderRow && invader.invaderColumn == newInvaderColumn {
                    self.invadersWhoCanFire.append(invader)
                }
            }
        }

        // Remove the hit invader from the firing list
        if let invaderIndex = invadersWhoCanFire.firstIndex(of: invader) {
            invadersWhoCanFire.remove(at: invaderIndex)
        }

        invader.removeFromParent()
        bullet.removeFromParent()
    }
}
