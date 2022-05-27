//
//  EvilSightModel.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 27/05/22.
//

import Foundation
import SpriteKit

class EvilSight: SKSpriteNode {
    
    init() {
    
    super.init(texture: SKTexture(imageNamed: "evil sight"), color: .purple, size: CGSize(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.height/1.8))
        
        self.alpha = 0.0
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: max(self.size.width/2, self.size.height/2))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = Collision.Masks.evilSight.bitmask
        self.physicsBody?.contactTestBitMask = Collision.Masks.goblin.bitmask
        self.physicsBody?.collisionBitMask = Collision.Masks.map.bitmask
        self.name = "evilSight"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func evilSight(position: CGPoint) {
        self.alpha = 1.0
        self.position = position
    }
    
    public func dispatchSight() {
        self.setScale(1.0)
        self.alpha = 0.0
    }
}
