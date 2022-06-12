//
//  DarkSonModel.swift
//  JGT
//
//  Created by Eugenio Raja on 24/05/22.
//

import Foundation
import SwiftUI
import SpriteKit

class DarkSon: SKSpriteNode, Identifiable, ObservableObject {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    @ObservedObject var hud: HUD = HUD.shared
    @ObservedObject var tutorialSheet: TutorialSheet = TutorialSheet.shared
    
//    public var lives: Int = 5
    
    public let maxHealth: Int = 500
    public var health: Int = 500
    public let attack: Int = 10
    public let desc: String = "“It’s my stupid and spoiled son, he’s strong as much as he’s stupid but I need to help him to become my successor”"
    
    public var target: Gate?  = nil
    
    public var spawnX: CGFloat = goblinmancyCircleCoordinates.x
    public var spawnY: CGFloat = goblinmancyCircleCoordinates.y + 300
    
    public var isDead: Bool = false
    
    private var attackCounter: Int = 0
    private var respawnCounter: Int = 0
    
    init() {
        super.init(texture: SKTexture(imageNamed: "darkson"), color: .red, size: CGSize(width: 300, height: 300))
        self.name = "darkson"
        self.speed = 6.0
        self.position.x = self.spawnX
        self.position.y = self.spawnY
        self.zPosition = 1

        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 1.5, height: self.size.height * 1))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = Collision.Masks.darkson.bitmask
        self.physicsBody?.collisionBitMask = Collision.Masks.building.bitmask | Collision.Masks.gate.bitmask
        self.physicsBody?.contactTestBitMask = Collision.Masks.projectile.bitmask | Collision.Masks.rangedEnemy.bitmask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        hud.livesCounter.text = "X \(gameLogic.lives)"

        if (self.health > 0) {
            var distance = CGVector(dx: gateCoordinates.x - position.x, dy: gateCoordinates.y - 50 - position.y)
            if let _ = self.action(forKey: "walk") {
                if (self.target != nil) {
                    removeAction(forKey: "walk")
                    self.attackCounter += 1
                    if (self.attackCounter % attackTime == 0) {
                        self.setGateParticles()

                        if UserDefaults.standard.bool(forKey: "gateTutorial") == false {
                        gameLogic.tutorialEvent(index: 9, hud: hud, tutorialSheet: tutorialSheet)
                            UserDefaults.standard.set(true, forKey: "gateTutorial")
                            hud.counter += 1
                            hud.tutorialCounter.alpha = 1.0
                            hud.tutorialCounter.text = String(hud.counter)
                        }
                        self.target!.health -= self.attack
                        self.attackCounter = 0
                        gameLogic.playSound(node: self, audio: Audio.EffectFiles.darkSonAttack, wait: false, muted: gameLogic.muted)
                    }
                }
            }
            else {
                distance = limitVector(vector: distance, max: 100)
                let time = getDuration(distance: distance, speed: self.speed)
                let walk = SKAction.move(by: distance, duration: time)
                self.run(walk, withKey: "walk")
            }
        }
        else {
            if (!self.isDead) {
                self.isDead = true
                self.position.x = self.spawnX
                self.position.y = self.spawnY
                self.alpha = 0.0
                self.respawnCounter += 1
                gameLogic.lives -= 1
                gameLogic.playSound(node: self.parent?.scene?.camera, audio: Audio.EffectFiles.darkSonGrunt, wait: false, muted: gameLogic.muted)
            }
            else {
                if gameLogic.lives == 0 {
                    gameLogic.isGameOver = true
                }
                else {
                self.respawnCounter += 1
                self.target = nil
                if (self.respawnCounter % tenSeconds == 0) {
                    self.setFireParticles()
                    self.alpha = 1.0
                    self.health = self.maxHealth
                    self.isDead = false
                    gameLogic.playSound(node: self, audio: Audio.EffectFiles.darkSonRebirth, wait: false, muted: gameLogic.muted)
                    }
                }
            }
        }
    }
   
    private func setFireParticles() {
        let fireParticle = SKEmitterNode(fileNamed: "FireParticle")
        fireParticle!.name = "fireParticle"
        fireParticle!.position.x = spawnX
        fireParticle!.position.y = spawnY
        fireParticle!.position.y -= 100
//        fireParticle!.zPosition = -1
        fireParticle!.particleColorSequence = nil
        fireParticle!.particleColorBlendFactor = 1.0
        fireParticle!.particleColor = UIColor(red: 125/255, green: 61/255, blue: 204/255, alpha: 1.0)
        fireParticle!.setScale(6)
        
        let smokeParticle = SKEmitterNode(fileNamed: "SmokeParticle")
        smokeParticle!.name = "smokeParticle"
        smokeParticle!.position.x = spawnX
        smokeParticle!.position.y = spawnY
        smokeParticle!.position.y -= 100
//        smokeParticle!.zPosition = -1
        smokeParticle!.setScale(3)
        
        let addFireParticle = SKAction.run({
            self.parent!.scene!.addChild(fireParticle!)
        })
        let removeFireParticle = SKAction.run({
            fireParticle!.removeFromParent()
        })
        
        let addSmokeParticle = SKAction.run({
            self.parent!.scene!.addChild(smokeParticle!)
        })
        let removeSmokeParticle = SKAction.run({
            smokeParticle!.removeFromParent()
        })

        let fireFade = SKAction.run({
            fireParticle!.run(SKAction.fadeOut(withDuration: 0.7))
        })
        let smokeFade = SKAction.run({
            smokeParticle!.run(SKAction.fadeOut(withDuration: 2))
        })
        
        let burnSequence = SKAction.sequence([
            addSmokeParticle,
            addFireParticle,
            fireFade,
            smokeFade,
        ])
        
        self.parent!.run(burnSequence, withKey: "burnTreeParticle")
        
        let removeSequence = SKAction.sequence([
            .wait(forDuration: 3),
            removeFireParticle,
            removeSmokeParticle
        ])
        
        self.parent!.run(removeSequence, withKey: "removeParticle")
    }
    
    private func setGateParticles() {
        let explosionParticle = SKEmitterNode(fileNamed: "ExplosionParticle")
        explosionParticle!.name = "explosionParticle"
        explosionParticle!.position.x = target!.position.x + CGFloat.random(in: -30...30)
        explosionParticle!.position.y = target!.position.y + CGFloat.random(in: -40...40)
        explosionParticle!.zPosition = -1
        explosionParticle!.particleColorSequence = nil
        explosionParticle!.particleColorBlendFactor = 1.0
        explosionParticle!.particleColor = UIColor(red: 125/255, green: 61/255, blue: 204/255, alpha: 1.0)
        
        let addExplosionParticle = SKAction.run({
            self.parent!.scene!.addChild(explosionParticle!)
        })
        let removeExplosionParticle = SKAction.run({
            explosionParticle!.removeFromParent()
        })
        let explosionFade = SKAction.run({
            explosionParticle!.run(SKAction.fadeOut(withDuration: 0.3))
        })
        
        let explosionSequence = SKAction.sequence([
            addExplosionParticle,
            explosionFade
        ])
        
        self.parent!.run(explosionSequence, withKey: "explosionParticle")
        
        let removeSequence = SKAction.sequence([
            .wait(forDuration: 1),
            removeExplosionParticle
        ])
        
        self.parent!.run(removeSequence, withKey: "removeExplosionParticle")
    }
}

