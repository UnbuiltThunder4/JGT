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
                    if (node2.type == .rock || node2.type == .catapult || node2.type == .tree || node2.type == .trap){
                        if node2.goblins.isEmpty {
                            node.closeStructure = node2
                            node2.goblins.append(node)
                        }
                    } else {
                        node.closeStructure = node2
                        node2.goblins.append(node)
                    }
                }
            }
            
            if let node = secondBody.node as? Goblin {
                if let node2 = firstBody.node as? Structure {
                    if (node2.type == .rock || node2.type == .catapult || node2.type == .tree || node2.type == .trap){
                        if node2.goblins.isEmpty {
                            node.closeStructure = node2
                            node2.goblins.append(node)
                        }
                    } else {
                        node.closeStructure = node2
                        node2.goblins.append(node)
                    }
                }
            }
        
        }
        if (collision.matches(.enemy, .goblin)) {
            
            if let node = firstBody.node as? Goblin {
                if let node2 = secondBody.node as? Enemy {
                    node.targetQueue.append(node2)
                    node2.targetQueue.append(node)
                }
            }
            if let node = secondBody.node as? Goblin {
                if let node2 = firstBody.node as? Enemy {
                    node.targetQueue.append(node2)
                    node2.targetQueue.append(node)
                }
            }
        
        }
        if (collision.matches(.gate, .darkson)) {
            
            if let node = firstBody.node as? DarkSon {
                if let node2 = secondBody.node as? Gate {
                    node.target = node2
                    print("done")
                }
            }
            if let node = secondBody.node as? DarkSon {
                if let node2 = firstBody.node as? Gate {
                    node.target = node2
                    print("done")
                }
            }
        
        }
        if (collision.matches(.goblin, .evilSight)) {
            if let node = firstBody.node as? Goblin {
                if let node2 = secondBody.node as? EvilSight {
                    node.isFrenzied = true
                    node.fear = 0
                    node.currentFrenzyTurn = node.frenzy
                    print(node.fullName)
                    print(node.isFrenzied)
                }
            }
            if let node = secondBody.node as? Goblin {
                if let node2 = firstBody.node as? EvilSight {
                    node.isFrenzied = true
                    node.fear = 0
                    node.currentFrenzyTurn = node.frenzy
                    print(node.fullName)
                    print(node.isFrenzied)
                }
            }
        }
    }
}
