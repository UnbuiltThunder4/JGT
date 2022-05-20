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
//            gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
            updateHealthBar(self.gaugeFill, withHealthPoints: Int(self.frame.size.height)/(self.maxFill) * (self.currentFill), withMaxHP: self.maxFill)
        }
        else {
            self.currentFill -= 4
            self.gaugeFill.run(SKAction.resize(toHeight: self.frame.size.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 0.2))
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
    
    func updateHealthBar(_ node: SKSpriteNode, withHealthPoints hp: Int, withMaxHP maxHP: Int) {
            
            let barSize = CGSize(width: self.size.width, height: self.size.height);
            
            let fillColor = UIColor(red: 123.0/255, green: 200.0/255, blue: 30.0/255, alpha:1)
            
            let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
            
            // create drawing context
            UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            // draw the outline for the health bar
            borderColor.setStroke()
            let borderRect = CGRect(origin: CGPoint.zero, size: barSize)
            context.stroke(borderRect, width: 0.5)
            
            // draw the health bar with a colored rectangle
            fillColor.setFill()
            let barWidth = (barSize.width + 1) * CGFloat(hp) / CGFloat(maxHP)
            let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
            context.fill(barRect)
            // extract image
//            guard let spriteImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
//            UIGraphicsEndImageContext()
            
            // set sprite texture and size
            node.texture = SKTexture(imageNamed: "gauge")
            node.size = barSize
        }
}
