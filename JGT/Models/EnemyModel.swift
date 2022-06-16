//
//  EnemyModel.swift
//  JGT
//
//  Created by Eugenio Raja on 13/05/22.
//

import Foundation
import SwiftUI
import SpriteKit

class EnemyPopulation: ObservableObject {
    @Published public var enemies: [Enemy]
    
    init(enemies: [Enemy]) {
        self.enemies = enemies
    }
}

class Enemy: SKSpriteNode, Identifiable, ObservableObject {
    public let id = UUID()
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    public var type: EnemyType
    
    public var state: EnemyState = .idle
    public var notDead: Bool = true
    
    public var maxHealth: Int
    public var health: Int
    public var maxShield: Int
    public var shield: Int
    public var attack: Int
    public var fullName: String = ""
    public var desc: String = ""
    
    public var target: Goblin? = nil
    public var darkTarget: DarkSon? = nil
    public var targetQueue: [Goblin] = []
    
    private var initialx: CGFloat
    private var initialy: CGFloat
    public let maskmodX: CGFloat
    public let maskmodY: CGFloat
    
    private var canRecoverShield: Bool = true
    
    private var attackCounter: Int = 0
    private var shieldCounter: Int = 0
    private var idleCounter: Int = 0
    
    private var oldPosition: CGPoint? = nil
    
    init(type: EnemyType, x: CGFloat, y: CGFloat) {
        var imgname = ""
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        self.type = type
        self.initialx = x
        self.initialy = y
        switch type {
            
        case .small:
            self.maxHealth = 300
            self.health = 300
            self.maxShield = 100
            self.shield = 100
            self.attack = 20
            self.fullName = "Infamous Gnome"
            self.desc = "“The Infamous gnomes are known for their knife passion.”"
            self.maskmodX = 2.5
            self.maskmodY = 2.5
            width = 82
            height = 114
            imgname = "gnomesmall"
            break
            
        case .bow:
            self.maxHealth = 200
            self.health = 200
            self.maxShield = 0
            self.shield = 0
            self.attack = 25
            self.fullName = "Archer Gnome"
            self.desc = "“The ranged soldiers of the gnome army, but everybody knows that ranged weapons are for cowards, so goblins can’t use them.”"
            self.maskmodX = 5
            self.maskmodY = 10
            width = 80
            height = 160
            imgname = "gnomebow"
            break
            
        case .axe:
            self.maxHealth = 600
            self.health = 600
            self.maxShield = 200
            self.shield = 200
            self.attack = 20
            self.fullName = "Axe-Wielding Gnome"
            self.desc = "“The bigger and bulkiest type of gnomes, they’re not really strong but are extremely hard to kill.”"
            self.maskmodX = 2.5
            self.maskmodY = 2.5
            width = 169
            height = 144
            imgname = "gnomeaxe"
            break
        }
        super.init(texture: SKTexture(imageNamed: imgname), color: .red, size: CGSize(width: width, height: height))
        self.name = "enemy"
        self.speed = 10.0
        self.position.x = x
        self.position.y = y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func ==(lhs: Enemy, rhs: Enemy) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func update(_ tossScene: TossScene) -> Bool {
        let Dead = self.checkHealth()
        if (self.health > 0) {
            
            self.shouldFlip()
            
            switch self.state {
                
            case .idle:
                idleUpdate()
                break
                
            case .fighting:
                attackUpdate(tossScene)
                break
                
            default:
                idleUpdate()
                break
            }
        }
        return Dead
    }
    
    private func checkHealth() -> Bool {
        if (self.health <= 0){
            return true
        }
        else {
            return false
        }
    }
    
    private func idleUpdate() {
        gameLogic.removeAnimation(enemy: self)
        if (self.idleCounter % threeSeconds == 0) {
            self.canRecoverShield = true
            self.idleCounter = 0
        }
        if (self.canRecoverShield) {
            self.shieldCounter += 1
            if (self.shieldCounter % oneSecond == 0) {
                self.shieldCounter = 0
                if (self.shield + 5 <= self.maxShield) {
                    self.shield += 5
                }
                else {
                    self.shield = self.maxShield
                }
            }
        }
        else {
            self.idleCounter += 1
        }
        if (self.target == nil) {
            if (self.targetQueue.isEmpty) {
                self.walkToOrigin()
                if (self.darkTarget != nil) {
                    self.state = .fighting
                }
            }
            else {
                self.target = self.targetQueue[0]
                self.targetQueue.remove(at: 0)
            }
        }
        else {
            if (self.target!.state != .invillage && self.target!.state != .inacademy && self.target!.state != .intavern) {
                self.state = .fighting
            }
            else {
                self.target = nil
            }
        }
    }
    
    private func attackUpdate(_ tossScene: TossScene) {
        self.canRecoverShield = false
        self.shieldCounter = 0
        self.idleCounter = 0
        
        if let _ = self.action(forKey: "walk") {
            if let _ = self.action(forKey: "walkAnimation") {
            }
            else {
                gameLogic.isWalkingAnimation(enemy: self)
            }
        }
        else {
            if let _ = self.action(forKey: "attackAnimation") {
            }
            else {
                gameLogic.isFightingAnimation(enemy: self)
            }
        }
        
        if (self.target != nil) {
            let targetType = self.target?.type
            if (self.target!.state != .invillage && self.target!.state != .inacademy && self.target!.state != .intavern) {
                if (self.type != .bow) {
                    let originalPosDistance = CGVector(dx: self.initialx - self.position.x, dy: self.initialy - self.position.y)
                    let targetDistance = CGVector(dx: self.target!.position.x - self.position.x, dy: self.target!.position.y - self.position.y)
                    if (isVectorSmallerThan(vector: targetDistance, other: 100)) {
                        self.attackCounter += 1
                        if (self.attackCounter % attackTime == 0) {
                            
                            if self.type == .axe {
                                gameLogic.playSound(node: self, audio: Audio.EffectFiles.axeGnomeAttack, wait: false, muted: gameLogic.muted)
                            } else {
                                gameLogic.playSound(node: self, audio: Audio.EffectFiles.smallGnomeAttack, wait: false, muted: gameLogic.muted)
                            }
                            
                            if (self.target!.type == .rock) {
                                self.target!.health -= self.attack / 2
                            }
                            else {
                                self.target!.health -= self.attack
                            }
                            self.attackCounter = 0
                            let attackParticle = SKEmitterNode(fileNamed: "AttackParticle")
                            attackParticle!.position = CGPoint(x: 0, y: 0)
                            attackParticle!.xScale = self.xScale
                            attackParticle!.name = "attackParticle"
                            let addParticle = SKAction.run({
                                self.addChild(attackParticle!)
                            })
                            let removeParticle = SKAction.run({
                                attackParticle!.removeFromParent()
                            })
                            
                            let sequence = SKAction.sequence([
                                addParticle,
                                .wait(forDuration: 0.5),
                                removeParticle
                            ])
                            
                            self.run(sequence, withKey: "attackParticle")
                        }
                    }
                    else {
                        let walkDistance = limitVector(vector: targetDistance, max: 50)
                        if (abs(originalPosDistance.dx) > 300 || abs(originalPosDistance.dy) > 300) {
                            self.state = .idle
                            self.target = nil
                            removeAction(forKey: "walk")
                            gameLogic.removeAnimation(enemy: self)
                        }
                        else {
                            if let _ = self.action(forKey: "walk") {
                            }
                            else {
                                let time = getDuration(distance: walkDistance, speed: self.speed)
                                let walk = SKAction.move(by: walkDistance, duration: time)
                                self.run(walk, withKey: "walk")
                                gameLogic.removeAnimation(enemy: self)
                            }
                        }
                    }
                    if (self.target != nil) {
                        if (self.target!.health <= 0) {
                            let goblinDeathParticle = SKEmitterNode(fileNamed: "GoblinDeathParticle")
                            goblinDeathParticle!.position = self.target!.position
                            goblinDeathParticle!.name = "goblinDeathParticle"
                            goblinDeathParticle!.zPosition = 1
                            goblinDeathParticle!.particleColorSequence = nil
                            goblinDeathParticle!.particleColorBlendFactor = 1.0
                            
                            switch self.target!.type {
                            case .rock:
                                goblinDeathParticle!.particleColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0)
                            case .fire:
                                goblinDeathParticle!.particleColor = UIColor(red: 224/255, green: 53/255, blue: 50/255, alpha: 1.0)
                            case .gum:
                                goblinDeathParticle!.particleColor = UIColor(red: 255/255, green: 141/255, blue: 157/255, alpha: 1.0)
                            case .normal:
                                goblinDeathParticle!.particleColor = UIColor(red: 11/255, green: 129/255, blue: 80/255, alpha: 1.0)
                            }
                            
                            let parent = self.parent!
                            
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
                            
                            self.target = nil
                            self.state = .idle
                            gameLogic.removeAnimation(enemy: self)
                            removeAction(forKey: "walk")
                            
                            switch targetType {
                            case .rock:
                                let random = Int.random(in: 0...1)
                                gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.stoneblinDeath1 : Audio.EffectFiles.stoneblinDeath3, wait: true, muted: gameLogic.muted)
                            case .fire:
                                let random = Int.random(in: 0...1)
                                gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.flameblinDeath1 : Audio.EffectFiles.flameblinDeath2, wait: true, muted: gameLogic.muted)
                            case .gum:
                                let random = Int.random(in: 0...1)
                                gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.gumblinDeath1 : Audio.EffectFiles.gumblinDeath2, wait: true, muted: gameLogic.muted)
                            case .normal:
                                let random = Int.random(in: 0...1)
                                gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.goblinDeath1 : Audio.EffectFiles.goblinDeath2, wait: true, muted: gameLogic.muted)
                            case .none:
                                break
                            }
                        }
                    }
                    else {
                        self.target = nil
                        self.state = .idle
                        gameLogic.removeAnimation(enemy: self)
                        removeAction(forKey: "walk")
                    }
                } else {
                    let targetDistance = CGVector(dx: self.target!.position.x - self.position.x, dy: self.target!.position.y - self.position.y)
                    if (isVectorSmallerThan(vector: targetDistance, other: 1000)) {
                        self.attackCounter += 1
                        if (self.attackCounter % attackTime == 0) {
                            self.attackCounter = 0
                            gameLogic.spawnProjectile(tossScene, spawnPoint: self.position, destinationPoint: self.target!.position, type: .arrow)
                        }
                        if (self.target != nil) {
                            if (self.target!.health <= 0) {
                                self.target = nil
                                self.state = .idle
                                gameLogic.removeAnimation(enemy: self)
                            }
                        }
                    }
                    else {
                        self.target = nil
                        self.state = .idle
                        gameLogic.removeAnimation(enemy: self)
                    }
                }
            }
        }
        else {
            if self.type != .bow {
                if darkTarget != nil {
                    let originalPosDistance = CGVector(dx: self.initialx - self.position.x, dy: self.initialy - self.position.y)
                    let targetDistance = CGVector(dx: self.darkTarget!.position.x - self.position.x, dy: self.darkTarget!.position.y - self.position.y)
                    if (isVectorSmallerThan(vector: targetDistance, other: 100)) {
                        self.attackCounter += 1
                        if (self.attackCounter % attackTime == 0) {
                            
                            if self.type == .axe {
                                gameLogic.playSound(node: self, audio: Audio.EffectFiles.axeGnomeAttack, wait: false, muted: gameLogic.muted)
                            } else {
                                gameLogic.playSound(node: self, audio: Audio.EffectFiles.smallGnomeAttack, wait: false, muted: gameLogic.muted)
                            }
                            
                            self.darkTarget!.health -= self.attack
                            
                            self.attackCounter = 0
                            let attackParticle = SKEmitterNode(fileNamed: "AttackParticle")
                            attackParticle!.position = CGPoint(x: 0, y: 0)
                            attackParticle!.xScale = self.xScale
                            attackParticle!.name = "attackParticle"
                            let addParticle = SKAction.run({
                                self.addChild(attackParticle!)
                            })
                            let removeParticle = SKAction.run({
                                attackParticle!.removeFromParent()
                            })
                            
                            let sequence = SKAction.sequence([
                                addParticle,
                                .wait(forDuration: 0.5),
                                removeParticle
                            ])
                            
                            self.run(sequence, withKey: "attackParticle")
                        }
                    }
                    else {
                        let walkDistance = limitVector(vector: targetDistance, max: 50)
                        if (abs(originalPosDistance.dx) > 300 || abs(originalPosDistance.dy) > 300) {
                            self.state = .idle
                            self.darkTarget = nil
                            gameLogic.removeAnimation(enemy: self)
                            removeAction(forKey: "walk")
                        }
                        else {
                            if let _ = self.action(forKey: "walk") {
                            }
                            else {
                                let time = getDuration(distance: walkDistance, speed: self.speed)
                                let walk = SKAction.move(by: walkDistance, duration: time)
                                self.run(walk, withKey: "walk")
                                gameLogic.removeAnimation(enemy: self)
                            }
                        }
                    }
                    if (self.darkTarget != nil) {
                        if (self.darkTarget!.health <= 0) {
                            let darkSonDeathParticle = SKEmitterNode(fileNamed: "GoblinDeathParticle")
                            darkSonDeathParticle!.position = self.darkTarget!.position
                            darkSonDeathParticle!.name = "darkSonDeathParticle"
                            darkSonDeathParticle!.zPosition = 1
                            darkSonDeathParticle!.particleColorSequence = nil
                            darkSonDeathParticle!.particleColorBlendFactor = 1.0
                            darkSonDeathParticle!.particleColor = .black
                            darkSonDeathParticle!.setScale(2.5)
                                                    
                            let parent = self.darkTarget!.parent!

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
                            self.darkTarget = nil
                            self.state = .idle
                            gameLogic.removeAnimation(enemy: self)
                            removeAction(forKey: "walk")
                            
                        }
                    }
                    else {
                        self.darkTarget = nil
                        self.state = .idle
                        gameLogic.removeAnimation(enemy: self)
                        removeAction(forKey: "walk")
                    }
                }
                else {
                    self.state = .idle
                    removeAction(forKey: "walk")
                    gameLogic.removeAnimation(enemy: self)
                }
            } else {
                if darkTarget != nil {
                    let targetDistance = CGVector(dx: self.darkTarget!.position.x - self.position.x, dy: self.darkTarget!.position.y - self.position.y)
                    if (isVectorSmallerThan(vector: targetDistance, other: 1000)) {
                        self.attackCounter += 1
                        if (self.attackCounter % attackTime == 0) {
                            self.attackCounter = 0
                            gameLogic.spawnProjectile(tossScene, spawnPoint: self.position, destinationPoint: self.darkTarget!.position, type: .arrow)
                        }
                        if (self.darkTarget != nil) {
                            if (self.darkTarget!.health <= 0) {
                                self.darkTarget = nil
                                self.state = .idle
                                gameLogic.removeAnimation(enemy: self)
                            }
                        }
                    }
                    else {
                        self.darkTarget = nil
                        self.state = .idle
                        gameLogic.removeAnimation(enemy: self)
                    }
                }
                else {
                    self.state = .idle
                    gameLogic.removeAnimation(enemy: self)
                }
            }
        }
    }
    
    private func walkToOrigin() {
        if ((position.x != self.initialx) || (position.y != self.initialy)) {
            if let _ = self.action(forKey: "walk") {
            }
            else {
                let distance = CGVector(dx: self.initialx - position.x, dy: self.initialy - position.y)
                let time = getDuration(distance: distance, speed: self.speed)
                let walk = SKAction.move(by: distance, duration: time)
                self.run(walk, withKey: "walk")
                gameLogic.removeAnimation(enemy: self)
            }
        }
    }
    
    private func shouldFlip() {
        
        if (self.oldPosition != nil) {
            if Int((self.oldPosition?.x)!) > Int((self.position.x)) {
                self.xScale = -1
                
            } else if Int((self.oldPosition?.x)!) < Int((self.position.x)) {
                self.xScale = 1
            }
        }
        
        self.oldPosition = self.position
    }
    
}
