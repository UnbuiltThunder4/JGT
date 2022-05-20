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
    
    public func update() {
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
    }
    
    private func idleUpdate() {
        if (self.target == nil) {
            if (!self.targetQueue.isEmpty) {
                self.target = self.targetQueue[0]
                self.targetQueue.remove(at: 0)
            }
            else {
                self.walkToOrigin()
                return
            }
        }
        else {
            if (self.target!.state != .inhand && self.target!.state != .invillage && self.target!.state != .inacademy && self.target!.state != .intavern) {
                removeAction(forKey: "walk")
                self.state = .fighting
                return
            }
            else {
                self.walkToOrigin()
                let targetDistance = CGVector(dx: self.target!.position.x - self.position.x, dy: self.target!.position.y - self.position.y)
                if (abs(targetDistance.dx) > 250 || abs(targetDistance.dy) > 250) {
                    self.state = .idle
                    self.target = nil
                    removeAction(forKey: "walk")
                    return
                }
            }
        }
    }
    
    private func attackUpdate() {
        if (self.target != nil) {
            if (self.target!.state != .inhand && self.target!.state != .invillage && self.target!.state != .inacademy && self.target!.state != .intavern) {
                let originalPosDistance = CGVector(dx: self.initialx - self.position.x, dy: self.initialy - self.position.y)
                let targetDistance = CGVector(dx: self.target!.position.x - self.position.x, dy: self.target!.position.y - self.position.y)
                let walkDistance = limitVector(vector: targetDistance, max: 20)
                if (abs(originalPosDistance.dx) > 250 || abs(originalPosDistance.dy) > 250) {
                    self.state = .idle
                    self.target = nil
                    removeAction(forKey: "walk")
//                    return
                }
                else {
                    if let _ = self.action(forKey: "walk") {
                        if (abs(targetDistance.dx) < 25 && abs(targetDistance.dy) < 25) {
                            self.target!.health -= self.attack //DAMAGE ONLY AT THE END OF ANIMATION
                            if (self.target!.health <= 0) {
                                self.target = nil
                                self.state = .idle
                                removeAction(forKey: "walk")
//                                return
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
                self.state = .idle
                removeAction(forKey: "walk")
//                return
            }
        }
        else {
            self.state = .idle
            removeAction(forKey: "walk")
//            return
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
