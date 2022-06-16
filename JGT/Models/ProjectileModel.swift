//
//  ProjectileModel.swift
//  JGT
//
//  Created by Eugenio Raja on 23/05/22.
//

import Foundation
import SwiftUI
import SpriteKit

class Projectile: SKSpriteNode, ObservableObject {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared

    let type: ProjectileType
    let mask: Collision.Masks
    let maskmod: CGFloat
    let width: CGFloat
    let height: CGFloat
    let damage: Int
    
    var oldPosition: CGPoint? = nil
        
    init(type: ProjectileType, x: CGFloat, y: CGFloat, rotation: Double) {
        var img = ""
        self.type = type
        var speed = 0.0
        switch type {
            
        case .arrow:
            img = "arrow"
            self.mask = .projectile
            self.width = 20
            self.height = 70
            self.maskmod = 1.0
            self.damage = 50
            speed = 30
            break
            
        case .rock:
            img = "rock"
            self.mask = .projectile
            self.width = 80
            self.height = 80
            self.maskmod = 1.0
            self.damage = 30
            speed = 18
            break
            
        }
        super.init(texture: SKTexture(imageNamed: img), color: .red, size: CGSize(width: self.width, height: self.height))
        self.name = img
        self.position.x = x
        self.position.y = y
        self.zRotation = rotation
        self.speed = speed
        self.zPosition = 1

        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.categoryBitMask = Collision.Masks.projectile.bitmask
        self.physicsBody?.contactTestBitMask = Collision.Masks.goblin.bitmask
        
        if (self.type == .arrow) {
            self.physicsBody?.collisionBitMask = Collision.Masks.enviroment.bitmask
        }
        else {
            self.physicsBody?.collisionBitMask = Collision.Masks.gate.bitmask
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        if (self.oldPosition != nil) {
            if Int((self.oldPosition?.x)!) > Int((self.position.x)) {
                self.xScale = -1
                
            } else if Int((self.oldPosition?.x)!) < Int((self.position.x)) {
                self.xScale = 1
            }
            if Int((self.oldPosition?.y)!) > Int((self.position.y)) {
                self.yScale = 1
                
            } else if Int((self.oldPosition?.y)!) < Int((self.position.y)) {
                self.yScale = -1
            }
        }
        
        self.oldPosition = self.position
    }
    
}
