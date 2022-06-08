//
//  EnemyModel.swift
//  JGT
//
//  Created by Eugenio Raja on 13/05/22.
//

import Foundation
import SwiftUI
import SpriteKit

class Enemy: SKSpriteNode, Identifiable, ObservableObject {
    public let id = UUID()
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    public var type: EnemyType
    
    public var state: EnemyState = .idle
    
    public var maxHealth: Int
    public var health: Int
    public var maxShield: Int
    public var shield: Int
    public var attack: Int
    
    public var target: Goblin? = nil
    public var targetQueue: [Goblin] = []
    
    private var initialx: CGFloat
    private var initialy: CGFloat
    public let maskmodX: CGFloat
    public let maskmodY: CGFloat
    
    private var canRecoverShield: Bool = true
    
    private var attackCounter: Int = 0
    private var shieldCounter: Int = 0
    private var idleCounter: Int = 0
    
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
            self.maskmodX = 2.5
            self.maskmodY = 2.5
            width = 60
            height = 120
            imgname = "gnomesmall"
            break
            
        case .bow:
            self.maxHealth = 400
            self.health = 400
            self.maxShield = 150
            self.shield = 150
            self.attack = 50
            self.maskmodX = 5
            self.maskmodY = 10
            width = 100
            height = 140
            imgname = "gnomebow"
            break
            
        case .axe:
            self.maxHealth = 600
            self.health = 600
            self.maxShield = 200
            self.shield = 200
            self.attack = 20
            self.maskmodX = 2.5
            self.maskmodY = 2.5
            width = 160
            height = 160
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
        let isDead = self.checkHealth()
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
        return isDead
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
                        }
                        else {
                            if let _ = self.action(forKey: "walk") {
                                
                            }
                            else {
                                let time = getDuration(distance: walkDistance, speed: self.speed)
                                let walk = SKAction.move(by: walkDistance, duration: time)
                                self.run(walk, withKey: "walk")
                            }
                        }
                    }
                    if (self.target != nil) {
                        if (self.target!.health <= 0) {
                            self.target = nil
                            self.state = .idle
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
                        removeAction(forKey: "walk")
                    }
                } else {
                    gameLogic.spawnProjectile(tossScene, spawnPoint: self.position, destinationPoint: self.target!.position, type: .arrow)
                }
            }
        }
        else {
            self.state = .idle
            removeAction(forKey: "walk")
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
            }
        }
    }
    
}
