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
        if (collision.matches(.meleeEnemy, .goblin)) {
            
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
        if (collision.matches(.rangedEnemy, .goblin)) {
            
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
        if (collision.matches(.rangedEnemy, .darkson)) {
            
            if let node = firstBody.node as? DarkSon {
                if let node2 = secondBody.node as? Enemy {
                    node2.darkTarget = node
                }
            }
            if let node = secondBody.node as? DarkSon {
                if let node2 = firstBody.node as? Enemy {
                    node2.darkTarget = node
                }
            }
        
        }
        
        if (collision.matches(.projectile, .darkson)) {
            
            if let node = firstBody.node as? DarkSon {
                if let node2 = secondBody.node as? Projectile {
                    if (node2.type == .arrow) {
                            node.health -= node2.damage
                        
                        if node.health <= 0 {
                            let darkSonDeathParticle = SKEmitterNode(fileNamed: "GoblinDeathParticle")
                            darkSonDeathParticle!.position = node.position
                            darkSonDeathParticle!.name = "darkSonDeathParticle"
                            darkSonDeathParticle!.zPosition = 1
                            darkSonDeathParticle!.particleColorSequence = nil
                            darkSonDeathParticle!.particleColorBlendFactor = 1.0
                            darkSonDeathParticle!.particleColor = .black
                            darkSonDeathParticle!.setScale(3)
                                                    
                            let parent = node.parent!.scene!

                            let addDeathParticle = SKAction.run({
                                parent.addChild(darkSonDeathParticle!)
                            })
                            let darkSonDeathFade = SKAction.run {
                                darkSonDeathParticle!.run(SKAction.fadeOut(withDuration: 0.4))
                            }
                            
                            let particleSequence = SKAction.sequence([
                                addDeathParticle,
                                darkSonDeathFade
                            ])

                            let removeDeathParticle = SKAction.run({
                                darkSonDeathParticle!.removeFromParent()
                            })

                            let removeSequence = SKAction.sequence([
                                .wait(forDuration: 0.5),
                                removeDeathParticle
                            ])

                            parent.run(particleSequence)
                            parent.run(removeSequence)
                        }
                    }
                }
            }
            if let node = secondBody.node as? DarkSon {
                if let node2 = firstBody.node as? Projectile {
                    if (node2.type == .arrow) {
                        node.health -= node2.damage
                        
                    if node.health <= 0 {
                        let darkSonDeathParticle = SKEmitterNode(fileNamed: "GoblinDeathParticle")
                        darkSonDeathParticle!.position = node.position
                        darkSonDeathParticle!.name = "darkSonDeathParticle"
                        darkSonDeathParticle!.zPosition = 1
                        darkSonDeathParticle!.particleColorSequence = nil
                        darkSonDeathParticle!.particleColorBlendFactor = 1.0
                        darkSonDeathParticle!.particleColor = .black
                        darkSonDeathParticle!.setScale(3)
                                                
                        let parent = node.parent!.scene!

                        let addDeathParticle = SKAction.run({
                            parent.addChild(darkSonDeathParticle!)
                        })
                        let darkSonDeathFade = SKAction.run {
                            darkSonDeathParticle!.run(SKAction.fadeOut(withDuration: 0.4))
                        }
                        
                        let particleSequence = SKAction.sequence([
                            addDeathParticle,
                            darkSonDeathFade
                        ])

                        let removeDeathParticle = SKAction.run({
                            darkSonDeathParticle!.removeFromParent()
                        })

                        let removeSequence = SKAction.sequence([
                            .wait(forDuration: 0.5),
                            removeDeathParticle
                        ])

                        parent.run(particleSequence)
                        parent.run(removeSequence)
                    }
                }
                }
            }
        
        }
        
        if (collision.matches(.projectile, .goblin)) {
            
            if let node = firstBody.node as? Goblin {
                if let node2 = secondBody.node as? Projectile {
                    if (node2.type == .arrow) {
                        if (node.type != .gum) {
                            node.health -= node2.damage
                        }
                        else {
                            node.health -= node2.damage/4
                        }
                        
                        if node.health <= 0 {
                            let goblinDeathParticle = SKEmitterNode(fileNamed: "GoblinDeathParticle")
                            goblinDeathParticle!.position = node.position
                            goblinDeathParticle!.name = "goblinDeathParticle"
                            goblinDeathParticle!.zPosition = 1
                            goblinDeathParticle!.particleColorSequence = nil
                            goblinDeathParticle!.particleColorBlendFactor = 1.0
                            
                            switch node.type {
                            case .rock:
                                goblinDeathParticle!.particleColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0)
                            case .fire:
                                goblinDeathParticle!.particleColor = UIColor(red: 224/255, green: 53/255, blue: 50/255, alpha: 1.0)
                            case .gum:
                                goblinDeathParticle!.particleColor = UIColor(red: 255/255, green: 141/255, blue: 157/255, alpha: 1.0)
                            case .normal:
                                goblinDeathParticle!.particleColor = UIColor(red: 11/255, green: 129/255, blue: 80/255, alpha: 1.0)
                            }
                                                    
                            let parent = node.parent!.scene!

                            let addDeathParticle = SKAction.run({
                                parent.addChild(goblinDeathParticle!)
                            })
                            let goblinDeathFade = SKAction.run {
                                goblinDeathParticle!.run(SKAction.fadeOut(withDuration: 0.4))
                            }
                            
                            let particleSequence = SKAction.sequence([
                                addDeathParticle,
                                goblinDeathFade
                            ])

                            let removeDeathParticle = SKAction.run({
                                goblinDeathParticle!.removeFromParent()
                            })

                            let removeSequence = SKAction.sequence([
                                .wait(forDuration: 0.5),
                                removeDeathParticle
                            ])

                            parent.run(particleSequence)
                            parent.run(removeSequence)
                        }
                    }
                }
            }
            if let node = secondBody.node as? Goblin {
                if let node2 = firstBody.node as? Projectile {
                    if (node2.type == .arrow) {
                        if (node.type != .gum) {
                            node.health -= node2.damage
                        }
                        else {
                            node.health -= node2.damage/4
                        }
                        
                        if node.health <= 0 {
                            let goblinDeathParticle = SKEmitterNode(fileNamed: "GoblinDeathParticle")
                            goblinDeathParticle!.position = node.position
                            goblinDeathParticle!.name = "goblinDeathParticle"
                            goblinDeathParticle!.zPosition = 1
                            goblinDeathParticle!.particleColorSequence = nil
                            goblinDeathParticle!.particleColorBlendFactor = 1.0
                            
                            switch node.type {
                            case .rock:
                                goblinDeathParticle!.particleColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0)
                            case .fire:
                                goblinDeathParticle!.particleColor = UIColor(red: 224/255, green: 53/255, blue: 50/255, alpha: 1.0)
                            case .gum:
                                goblinDeathParticle!.particleColor = UIColor(red: 255/255, green: 141/255, blue: 157/255, alpha: 1.0)
                            case .normal:
                                goblinDeathParticle!.particleColor = UIColor(red: 11/255, green: 129/255, blue: 80/255, alpha: 1.0)
                            }
                                                    
                            let parent = node.parent!.scene!

                            let addDeathParticle = SKAction.run({
                                parent.addChild(goblinDeathParticle!)
                            })
                            let goblinDeathFade = SKAction.run {
                                goblinDeathParticle!.run(SKAction.fadeOut(withDuration: 0.4))
                            }
                            
                            let particleSequence = SKAction.sequence([
                                addDeathParticle,
                                goblinDeathFade
                            ])

                            let removeDeathParticle = SKAction.run({
                                goblinDeathParticle!.removeFromParent()
                            })

                            let removeSequence = SKAction.sequence([
                                .wait(forDuration: 0.5),
                                removeDeathParticle
                            ])

                            parent.run(particleSequence)
                            parent.run(removeSequence)
                        }
                    }
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
                        if UserDefaults.standard.bool(forKey: "frenzyTutorial") == false {
                        gameLogic.tutorialEvent(index: 7, hud: hud, tutorialSheet: tutorialSheet)
                            UserDefaults.standard.set(true, forKey: "frenzyTutorial")
                            hud.counter += 1
                            hud.tutorialCounter.alpha = 1.0
                            hud.tutorialCounter.text = String(hud.counter)
                        }
                        
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
                        if UserDefaults.standard.bool(forKey: "frenzyTutorial") == false {
                        gameLogic.tutorialEvent(index: 7, hud: hud, tutorialSheet: tutorialSheet)
                            UserDefaults.standard.set(true, forKey: "frenzyTutorial")
                            hud.counter += 1
                            hud.tutorialCounter.alpha = 1.0
                            hud.tutorialCounter.text = String(hud.counter)
                        }
                        
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
