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
    
    public var lives: Int = 5
    
    public let maxHealth: Int = 500
    public var health: Int = 500
    public let attack: Int = 10
    
    public var target: Gate?  = nil
    public var gateNumber: Int = 1
    
    public var spawnX: CGFloat = 150
    public var spawnY: CGFloat = 150
    
    init() {
        super.init(texture: SKTexture(imageNamed: "darkson"), color: .red, size: CGSize(width: 300, height: 300))
        self.name = "darkson"
        self.speed = 6.0
        self.position.x = self.spawnX
        self.position.y = self.spawnY
        self.zPosition = 1

        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 1.5, height: self.size.height * 1.5))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = Collision.Masks.darkson.bitmask
        self.physicsBody?.collisionBitMask = Collision.Masks.building.bitmask | Collision.Masks.gate.bitmask
        self.physicsBody?.contactTestBitMask = Collision.Masks.projectile.bitmask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        var distance = CGVector(dx: gateCoordinates.x - position.x, dy: gateCoordinates.y - 400 - position.y)
        if let _ = self.action(forKey: "walk") {
            if (self.target != nil) {
                removeAction(forKey: "walk")
                self.target!.health -= 1 //self.attack
            }
        }
        else {
            distance = limitVector(vector: distance, max: 100)
            let time = getDuration(distance: distance, speed: self.speed)
            let walk = SKAction.move(by: distance, duration: time)
            self.run(walk, withKey: "walk")
        }
    }
    
}

