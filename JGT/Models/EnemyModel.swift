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
        else {
            removeAction(forKey: "walk")
//            removeAction(forKey: "walk")
            self.state = .fighting
        }
    }
    
    private func attackUpdate() {
        
        //ATTACK HERE
        if (self.target != nil) {
            let dist = CGVector(dx: self.initialx - self.position.x, dy: self.initialy - self.position.y)
            let distance = CGVector(dx: self.target!.position.x - self.position.x, dy: self.target!.position.y - self.position.y)
            if (dist.dx > 100 && dist.dy > 100) {
                self.state = .idle
                self.target = nil
            }
            else {
                if let _ = self.action(forKey: "walk") {
                    
                }
                else {
                    let time = getDuration(distance: distance, speed: self.speed)
                    let walk = SKAction.move(by: distance, duration: time)
                    self.run(walk, withKey: "walk")
                }
            }
            if (distance.dx < 3 && distance.dy < 3) {
//                self.target!.health -= self.attack
                //DAMAGE ONLY AT THE END OF ANIMATION
            }
        }
        else {
            self.state = .idle
        }
    }
    
}
