//
//  EvilGaugeModel.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 14/05/22.
//

import Foundation
import SpriteKit

class EvilGauge: SKSpriteNode {
    let maxFill: Int
    public var currentFill: Int
    
    let gaugeFill: SKSpriteNode = SKSpriteNode()
    
    init(maxFill: Int, currentFill: Int) {
        
        self.maxFill = maxFill
        self.currentFill = currentFill
        
        super.init(texture: SKTexture(imageNamed: "gauge"), color: .black, size: CGSize(width: 20, height: 300))
        self.name = "evilGauge"
        
        gaugeFill.zPosition = 100
        gaugeFill.size = CGSize(width: self.frame.size.width,
                                height: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill))
        gaugeFill.color = .green
        gaugeFill.alpha = 0.8
        gaugeFill.name = "gaugeFill"
        addChild(gaugeFill)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkSpawn(type: GoblinType) -> Bool {
        switch type {
        case .normal:
            if self.currentFill - 2 >= 0 {return true}
            break
        case .rock:
            if self.currentFill - 4 >= 0 {return true}
            break
        case .fire:
            if self.currentFill - 4 >= 0 {return true}
            break
        case .gum:
            if self.currentFill - 4 >= 0 {return true}
            break
        }
        return false
    }
    
    func shootGauge(goblin: Goblin) {
        if goblin.type == .normal {
            self.currentFill -= 2
            gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
        }
        else {
            self.currentFill -= 4
            gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
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
                    gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
                } else if self.currentFill != self.maxFill {
                    self.currentFill = self.maxFill
                    gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
                }
            }
            else {
                amount = goblin.age/2 + 3
                if (self.currentFill + amount) < self.maxFill {
                    self.currentFill += amount
                    gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
                } else if self.currentFill != self.maxFill {
                    self.currentFill = self.maxFill
                    gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
                }
            }
        }
        else if let value = value {
            amount = value
            if (self.currentFill + amount) < self.maxFill {
                self.currentFill += amount
                gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
            } else if self.currentFill != self.maxFill {
                self.currentFill = self.maxFill
                gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
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
