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
    
    public func update() -> Bool {
        let isDead = self.checkHealth()
        switch self.state {
            
        case .idle:
            idleUpdate()
            break
            
        case .fighting:
            attackUpdate()
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
    
    private func attackUpdate() {
        self.canRecoverShield = false
        self.shieldCounter = 0
        self.idleCounter = 0
        if (self.target != nil) {
            if (self.target!.state != .invillage && self.target!.state != .inacademy && self.target!.state != .intavern) {
                let originalPosDistance = CGVector(dx: self.initialx - self.position.x, dy: self.initialy - self.position.y)
                let targetDistance = CGVector(dx: self.target!.position.x - self.position.x, dy: self.target!.position.y - self.position.y)
                let walkDistance = limitVector(vector: targetDistance, max: 20)
                if (abs(originalPosDistance.dx) > 300 || abs(originalPosDistance.dy) > 300) {
                    self.state = .idle
                    self.target = nil
                    removeAction(forKey: "walk")
                }
                else {
                    if let _ = self.action(forKey: "walk") {
                        if (abs(targetDistance.dx) < 60 && abs(targetDistance.dy) < 60) {
                            self.attackCounter += 1
                            if (self.attackCounter % attackTime == 0) {
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
                            if (self.target!.health <= 0) {
                                self.target = nil
                                self.state = .idle
                                removeAction(forKey: "walk")
                            }
                        }
                    }
                    else {
                        let time = getDuration(distance: walkDistance, speed: self.speed)
                        let walk = SKAction.move(by: walkDistance, duration: time)
                        self.run(walk, withKey: "walk")
                    }
                }
            }
            else {
                self.target = nil
                self.state = .idle
                removeAction(forKey: "walk")
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
