//
//  EvilSightModel.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 27/05/22.
//

import Foundation
import SpriteKit

class EvilSight: SKSpriteNode {
    
    var evilCounter: Int = 29
    let halfSecond = 30
    
    init() {
        
        super.init(texture: SKTexture(imageNamed: "evil sight"), color: .purple, size: CGSize(width: UIScreen.main.bounds.width/17.0, height: UIScreen.main.bounds.width/17.0))
        
        self.alpha = 0.0
        self.zPosition = 4
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
        self.evilCounter += 1
        if (self.evilCounter % halfSecond == 0) {
            self.evilCounter = 0
            self.run(SKAction.scale(by: 1.1, duration: 0.5))
        }
    }
    
    public func dispatchSight() {
        self.setScale(1.0)
        self.alpha = 0.0
    }
}
