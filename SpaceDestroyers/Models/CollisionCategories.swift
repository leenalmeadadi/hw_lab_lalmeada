import Foundation

// each one is a different bit so they can be combined with |
struct CollisionCategories {
    static let invader: UInt32       = 0x1 << 0
    static let player: UInt32        = 0x1 << 1
    static let invaderBullet: UInt32 = 0x1 << 2
    static let playerBullet: UInt32  = 0x1 << 3
    static let edgeBody: UInt32      = 0x1 << 4
}
