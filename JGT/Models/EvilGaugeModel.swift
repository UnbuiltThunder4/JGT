//
//  EvilGaugeModel.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 14/05/22.
//

import Foundation
import SpriteKit

class EvilGauge: SKNode {
    let maxFill: Int
    public var currentFill: Int
    
    let gaugeBorder: SKSpriteNode = SKSpriteNode(imageNamed: "gauge")
    let gaugeFill: SKSpriteNode = SKSpriteNode()
    
    init(maxFill: Int, currentFill: Int) {
        
        self.maxFill = maxFill
        self.currentFill = currentFill
        
        super.init()
        self.name = "evilGauge"
        
        gaugeBorder.zPosition = 100
        gaugeBorder.name = "gaugeBorder"
        gaugeBorder.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.addChild(gaugeBorder)
        
        gaugeFill.zPosition = 100
        gaugeFill.size = CGSize(width: 20,
                                height: 300/CGFloat(self.maxFill) * CGFloat(self.currentFill))
        gaugeFill.color = .green
        gaugeFill.alpha = 0.8
        gaugeFill.name = "gaugeFill"
        self.addChild(gaugeFill)
        gaugeFill.anchorPoint = CGPoint(x: 0.5, y: 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkSpawn(type: GoblinType) -> Bool {
        if type == .normal {
            if self.currentFill - 2 >= 0 {return true}
        }
        else {
            if self.currentFill - 4 >= 0 {return true}
        }
        return false
    }
    
    func shootGauge(goblin: Goblin) {
        if goblin.type == .normal {
            self.currentFill -= 2
            gaugeFill.run(SKAction.resize(toHeight: gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
            print(gaugeFill.size)
        }
        else {
            self.currentFill -= 4
            self.gaugeFill.run(SKAction.resize(toHeight: gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
        }
        
    }
    
    func updateGauge(goblin: Goblin?, value: Int?) {
        var amount = 0
        if let goblin = goblin {
            
            if goblin.type == .normal {
                amount = goblin.age/2
                if (self.currentFill + amount) < self.maxFill {
                    self.currentFill += amount
                    print(amount)
                    gaugeFill.run(SKAction.resize(toHeight: gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
                } else if self.currentFill != self.maxFill {
                    self.currentFill = self.maxFill
                    gaugeFill.run(SKAction.resize(toHeight: gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
                }
            }
            else {
                amount = goblin.age/2 + 3
                if (self.currentFill + amount) < self.maxFill {
                    self.currentFill += amount
                    gaugeFill.run(SKAction.resize(toHeight: gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
                } else if self.currentFill != self.maxFill {
                    self.currentFill = self.maxFill
                    gaugeFill.run(SKAction.resize(toHeight: gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
                }
            }
        }
        else if let value = value {
            amount = value
            if (self.currentFill + amount) < self.maxFill {
                self.currentFill += amount
                gaugeFill.run(SKAction.resize(toHeight: gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
            } else if self.currentFill != self.maxFill {
                self.currentFill = self.maxFill
                gaugeFill.run(SKAction.resize(toHeight: gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
            }
        }
        
    }
    
    func updateGaugeColor(goblin: Goblin?) {
        if let goblin = goblin {
            switch goblin.type {
            case .normal:
                gaugeFill.color = .green
                break
            case .fire:
                gaugeFill.color = .red
                break
            case .rock:
                gaugeFill.color = .yellow
                break
            case .gum:
                gaugeFill.color = .systemPink
                break
            }
            
        }
        else {
            gaugeFill.color = .purple
        }
        
    }
    
}
