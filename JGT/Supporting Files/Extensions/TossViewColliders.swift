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
                if let _ = secondBody.node as? EvilSight {
                    
                    if !node.isFrenzied {
                    switch node.type {
                    case .rock:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: node, audio: random == 0 ? Audio.EffectFiles.stoneblinFrenzy1 : Audio.EffectFiles.stoneblinFrenzy2, wait: false, muted: gameLogic.muted)
                    case .fire:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: node, audio: random == 0 ? Audio.EffectFiles.flameblinFrenzy1 : Audio.EffectFiles.flameblinFrenzy2, wait: false, muted: gameLogic.muted)
                    case .gum:
                        gameLogic.playSound(node: node, audio: Audio.EffectFiles.gumblinFrenzy1, wait: false, muted: gameLogic.muted)
                    case .normal:
                        gameLogic.playSound(node: node, audio: Audio.EffectFiles.goblinFrenzy1, wait: false, muted: gameLogic.muted)
                    }
                    }
                    node.isFrenzied = true
                    node.fear = 0
                    node.currentFrenzyTurn = node.frenzy
                    print(node.fullName)
                    print(node.isFrenzied)
                    
                    let frenzyParticle = SKEmitterNode(fileNamed: "FrenzyParticle")
                    frenzyParticle!.name = "frenzyParticle"
                    frenzyParticle!.position = CGPoint(x: 0.0, y: 0.0)
                    frenzyParticle!.setScale(1.5)
                    
                    node.addChild(frenzyParticle!)
                }
            }
            if let node = secondBody.node as? Goblin {
                if let _ = firstBody.node as? EvilSight {
                    
                    if !node.isFrenzied {
                    switch node.type {
                    case .rock:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: node, audio: random == 0 ? Audio.EffectFiles.stoneblinFrenzy1 : Audio.EffectFiles.stoneblinFrenzy2, wait: false, muted: gameLogic.muted)
                    case .fire:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: node, audio: random == 0 ? Audio.EffectFiles.flameblinFrenzy1 : Audio.EffectFiles.flameblinFrenzy2, wait: false, muted: gameLogic.muted)
                    case .gum:
                        gameLogic.playSound(node: node, audio: Audio.EffectFiles.gumblinFrenzy1, wait: false, muted: gameLogic.muted)
                    case .normal:
                        gameLogic.playSound(node: node, audio: Audio.EffectFiles.goblinFrenzy1, wait: false, muted: gameLogic.muted)
                    }
                    }
                    
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
