import SpriteKit
import CoreMotion

extension GameScene {

    // MARK: - Setup Methods

    // Configures accelerometer for tilt-based player movement
    func setupAccelerometer() {
        // simulator has no accelerometer so this just returns there
        guard motionManager.isAccelerometerAvailable,
              let currentQueue = OperationQueue.current else {
            return
        }

        motionManager.accelerometerUpdateInterval = Constants.Input.accelerometerUpdateInterval
        motionManager.startAccelerometerUpdates(to: currentQueue) { data, error in
            if let acceleration = data?.acceleration {
                self.accelerationX = CGFloat(acceleration.x)
            }
        }
    }

    // Creates and positions the invader grid based on current level
    func setupInvaders() {
        let currentLevel = GameStateManager.shared.currentLevel
        // level 1 = 3 per row, level 2 = 5, level 3 = 7
        let numberOfInvaders = currentLevel * Constants.Invader.invadersPerLevelMultiplier
                               + Constants.Invader.invadersPerLevelBase
        for i in 1...rowsOfInvaders {
            for j in 1...numberOfInvaders {
                let tempInvader = Invader()
                let invaderHalfWidth = tempInvader.size.width / 2
                let xPositionStart = size.width/2 - invaderHalfWidth
                                     - (CGFloat(currentLevel) * tempInvader.size.width)
                                     + Constants.Invader.horizontalSpacing
                tempInvader.position = CGPoint(
                    x: xPositionStart + ((tempInvader.size.width + Constants.Invader.horizontalSpacing) * CGFloat(j - 1)),
                    y: self.size.height - CGFloat(i) * Constants.Invader.verticalSpacing
                )
                tempInvader.invaderRow = i
                tempInvader.invaderColumn = j
                addChild(tempInvader)
                // Only invaders in the bottom row can initially fire
                if i == rowsOfInvaders {
                    invadersWhoCanFire.append(tempInvader)
                }
            }
        }
    }

    // Positions the player sprite at the bottom center of the screen
    func setupPlayer() {
        player.position = CGPoint(
            x: self.frame.midX,
            y: player.size.height/2 + Constants.Player.bottomOffset
        )
        addChild(player)
    }

    // Called when the scene is presented - initializes physics, game objects, and input
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        // border around the screen so the player can't move off it
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.edgeBody
        backgroundColor = SKColor.black
        setupInvaders()
        setupPlayer()
        invokeInvaderFire()
        setupAccelerometer()
    }
}
