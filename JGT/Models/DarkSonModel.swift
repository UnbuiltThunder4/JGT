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
    //@ObservedObject var tossScene.hud: tossScene.hud
    @ObservedObject var tutorialSheet: TutorialSheet = TutorialSheet.shared
    
    public var lives: Int = 5
    public let maxHealth: Int = 500
    public var health: Int = 500
    public let attack: Int = 10
    public let desc: String = "“It’s my stupid and spoiled son, he’s strong as much as he’s stupid but I need to help him to become my successor”"
    
    public var target: Gate?  = nil
    
    public var spawnX: CGFloat?
    public var spawnY: CGFloat?
    
    public var isDead: Bool = false
    
    private var attackCounter: Int = 0
    private var respawnCounter: Int = 0
    
    init() {
        super.init(texture: SKTexture(imageNamed: "darkson"), color: .red, size: CGSize(width: 233, height: 333))
        self.name = "darkson"
        self.speed = 26.0
//        self.position.x = self.spawnX
//        self.position.y = self.spawnY
        
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 1.0, height: self.size.height * 0.8))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = Collision.Masks.darkson.bitmask
        self.physicsBody?.collisionBitMask = Collision.Masks.building.bitmask | Collision.Masks.gate.bitmask
        self.physicsBody?.contactTestBitMask = Collision.Masks.projectile.bitmask | Collision.Masks.rangedEnemy.bitmask | Collision.Masks.meleeEnemy.bitmask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ tossScene: TossScene) {
        if (self.health > 0) {
            var distance = CGVector(dx: gateCoordinates.x - position.x, dy: gateCoordinates.y - 50 - position.y)
            if (self.target != nil) {
                if let _ = self.action(forKey: "attackAnimation") {
                }
                else {
                    darkSonAttackAnimation()
                }
                
                self.attackCounter += 1
                if (self.attackCounter % attackTime == 0) {
                    self.setGateParticles()
                    
                    
                    if UserDefaults.standard.bool(forKey: "gateTutorial") == false {
                        gameLogic.tutorialEvent(index: 9, hud: tossScene.hud, tutorialSheet: tutorialSheet)
                        UserDefaults.standard.set(true, forKey: "gateTutorial")
                        tossScene.hud.counter += 1
                        tossScene.hud.tutorialCounter.alpha = 1.0
                        tossScene.hud.tutorialCounter.text = String(tossScene.hud.counter)
                    }
                    self.target!.health -= self.attack
                    self.attackCounter = 0
                    gameLogic.playSound(node: self, audio: Audio.EffectFiles.darkSonAttack, wait: false, muted: gameLogic.muted)
                }
                
            }
            if let _ = self.action(forKey: "walk") {
            }
            else {
                distance = limitVector(vector: distance, max: 100)
                let time = getDuration(distance: distance, speed: self.speed)
                let walk = SKAction.move(by: distance, duration: time)
                self.run(walk, withKey: "walk")
                if let _ = self.action(forKey: "walkAnimation") {
                }
                else {
                    darkSonWalkAnimation()
                }
            }
        }
        else {
            removeAction(forKey: "walk")
            removeAction(forKey: "walkAnimation")
            removeAction(forKey: "attackAnimation")
            
            if (!self.isDead) {
                self.isDead = true
                self.position.x = self.spawnX!
                self.position.y = self.spawnY!
                self.alpha = 0.0
                self.respawnCounter += 1
                self.lives -= 1
                tossScene.hud.livesCounter.text = "X \(self.lives)"
                gameLogic.playSound(node: self.parent?.scene?.camera, audio: Audio.EffectFiles.darkSonGrunt, wait: false, muted: gameLogic.muted)
                if self.lives == 0 {
                    gameLogic.finishTheGame(tossScene)
                }
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
    
    private func setFireParticles() {
        let fireParticle = SKEmitterNode(fileNamed: "FireParticle")
        fireParticle!.name = "fireParticle"
        fireParticle!.position.x = spawnX!
        fireParticle!.position.y = spawnY!
        fireParticle!.position.y -= 100
        //        fireParticle!.zPosition = -1
        fireParticle!.particleColorSequence = nil
        fireParticle!.particleColorBlendFactor = 1.0
        fireParticle!.particleColor = UIColor(red: 125/255, green: 61/255, blue: 204/255, alpha: 1.0)
        fireParticle!.setScale(6)
        
        let smokeParticle = SKEmitterNode(fileNamed: "SmokeParticle")
        smokeParticle!.name = "smokeParticle"
        smokeParticle!.position.x = spawnX!
        smokeParticle!.position.y = spawnY!
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
        explosionParticle!.setScale(1.3)
        
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
            .wait(forDuration: 2),
            removeExplosionParticle
        ])
        
        self.parent!.run(removeSequence, withKey: "removeExplosionParticle")
    }
    
    public func darkSonWalkAnimation() {
        var walkAnimationTextures : [SKTexture] = []
        
        for i in 1...8 {
            walkAnimationTextures.append(SKTexture(imageNamed: "walk\(i)"))
        }
        
        let walkAnimation = SKAction.animate(with: walkAnimationTextures, timePerFrame: 0.5)
        let walkAnimationSequence = SKAction.sequence([
            walkAnimation,
            walkAnimation.reversed()
        ])
        let walkAnimationRepeated = SKAction.repeatForever(walkAnimationSequence)
        
        self.run(walkAnimationRepeated, withKey: "walkAnimation")
    }
    
    public func darkSonAttackAnimation() {
        var attackAnimationTextures : [SKTexture] = []
        
        for i in 1...7 {
            attackAnimationTextures.append(SKTexture(imageNamed: "attack\(i)"))
        }
        
        let attackAnimation = SKAction.animate(with: attackAnimationTextures, timePerFrame: 0.5)
        
        self.run(attackAnimation, withKey: "attackAnimation")
    }
}

