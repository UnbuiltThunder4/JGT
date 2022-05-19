//
//  TossViewColliders.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 12/05/22.
//

import Foundation
import SpriteKit

extension TossScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
    
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        let collision = Collision(masks: (first: firstBody.categoryBitMask, second: secondBody.categoryBitMask))
        if (collision.matches(.building, .goblin) || collision.matches(.enviroment, .goblin)) {
            
            if let node = firstBody.node as? Goblin {
                if let node2 = secondBody.node as? Structure {
                    node.closeStructure = node2
                }
            }
            if let node = secondBody.node as? Goblin {
                if let node2 = firstBody.node as? Structure {
                    node.closeStructure = node2
                }
            }
        
        }
        if (collision.matches(.enemy, .goblin)) {
            
            if let node = firstBody.node as? Goblin {
                if let node2 = secondBody.node as? Enemy {
                    node2.target = node
                }
            }
            if let node = secondBody.node as? Goblin {
                if let node2 = firstBody.node as? Enemy {
                    node2.target = node
                }
            }
        
        }
    }
}
