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
    var sightCounter: Int = 59
    let oneSecond = 60
    let gaugeBorder: SKSpriteNode = SKSpriteNode(imageNamed: "gauge")
    let gaugeFill: SKSpriteNode = SKSpriteNode()
    let bottomGauge: SKSpriteNode = SKSpriteNode(imageNamed: "green-gauge")
    let gaugeBezel: SKSpriteNode = SKSpriteNode(imageNamed: "green-gauge-bezel")
    
    init(maxFill: Int, currentFill: Int, size: CGSize) {
        
        self.maxFill = maxFill
        self.currentFill = currentFill
        
//        super.init(texture: SKTexture(imageNamed: "green-gauge"), color: .red, size: CGSize(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/1.2))
        super.init(texture: SKTexture(imageNamed: "green-gauge"), color: .red, size: size)
        self.name = "evilGauge"
        self.zPosition = 80
    
        gaugeBorder.name = "gaugeBorder"
        gaugeBorder.size = CGSize(width: UIScreen.main.bounds.height/31,
                                  height: (UIScreen.main.bounds.height/2))
        gaugeBorder.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.addChild(gaugeBorder)

        gaugeFill.size = CGSize(width: UIScreen.main.bounds.height/31,
                                height: (UIScreen.main.bounds.height/2)/CGFloat(self.maxFill) * CGFloat(self.currentFill))
        gaugeFill.color = UIColor(red: 11/255, green: 129/255, blue: 80/255, alpha: 1.0)
        gaugeFill.name = "gaugeFill"
        self.addChild(gaugeFill)
        gaugeFill.anchorPoint = CGPoint(x: 0.5, y: 0.0)

        gaugeBezel.name = "gaugeBezel"
        gaugeBezel.size = size
        self.addChild(gaugeBezel)
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
            } else if self.currentFill + amount < 0 {
                gaugeFill.size.height = 0.0
            }
        }
        
    }
    
    func channelingSight() {
        self.sightCounter += 1
        if (self.sightCounter % oneSecond == 0) {
            if (self.currentFill) >= 0 {
                self.sightCounter = 0
                self.currentFill -= 1
                gaugeFill.run(SKAction.resize(toHeight: gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill), duration: 1.0))
            }
        }
    }
    
    func stopChanneling() {
        gaugeFill.size.height = gaugeBorder.frame.height/CGFloat(self.maxFill) * CGFloat(self.currentFill)
        self.sightCounter = 59
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
