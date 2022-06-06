//
//  CauldronModel.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import Foundation
import SpriteKit
import SwiftUI

class Cauldron: SKSpriteNode {
    
    var currentGoblinsNumberLabel: SKLabelNode = SKLabelNode()
    let goblinHead: SKSpriteNode = SKSpriteNode(imageNamed: "normalHead")
    let flameblinHead: SKSpriteNode = SKSpriteNode(imageNamed: "fireHead")
    let rockHead: SKSpriteNode = SKSpriteNode(imageNamed: "rockHead")
    let gumblingHead: SKSpriteNode = SKSpriteNode(imageNamed: "gumHead")
    var goblinCount: SKLabelNode = SKLabelNode()
    var flameblinCount: SKLabelNode = SKLabelNode()
    var rockCount: SKLabelNode = SKLabelNode()
    var gumblingCount: SKLabelNode = SKLabelNode()
    var currentGoblinsNumber: Int
    let maxGoblinNumber: Int
    
    init(currentGoblinsNumber: Int, maxGoblinNumber: Int) {
        
        self.currentGoblinsNumber = currentGoblinsNumber
        self.maxGoblinNumber = maxGoblinNumber
        
        super.init(texture: SKTexture(imageNamed: "cauldronn"), color: .red, size: CGSize(width: UIScreen.main.bounds.height/5, height: UIScreen.main.bounds.height/5))
        self.name = "cauldron"
        self.zPosition = 100
        
        currentGoblinsNumberLabel.name = "goblinsNumber"
        currentGoblinsNumberLabel.position = CGPoint(x: 0.0, y: self.frame.midY - self.frame.maxY/4)
        currentGoblinsNumberLabel.isUserInteractionEnabled = false
        
        self.addChild(currentGoblinsNumberLabel)
        
        self.goblinHead.size = CGSize(width: self.size.width/2, height: self.size.width/4)
        self.goblinHead.position = CGPoint(x: self.position.x + self.size.width + self.goblinHead.size.width/4,
                                           y: self.position.y)
        self.goblinHead.color = .green
        self.goblinHead.zPosition = 100
        self.goblinHead.alpha = 0
        self.goblinHead.name = "normalHead"
        self.addChild(goblinHead)
        
        self.goblinCount.position = CGPoint(x: self.goblinHead.position.x + self.goblinHead.size.width/1.5,
                                            y: self.goblinHead.position.y - self.goblinHead.frame.maxY * 0.30)
        self.goblinCount.zPosition = 100
        self.goblinCount.alpha = 0
        self.goblinCount.name = "goblinCount"
        self.addChild(goblinCount)
        
        self.flameblinHead.size = CGSize(width: self.size.width/2, height: self.size.width/4)
        self.flameblinHead.position = CGPoint(x: self.position.x + self.size.width + self.flameblinHead.size.width/4,
                                              y: self.position.y + self.size.height/2)
        self.flameblinHead.color = .red
        self.flameblinHead.zPosition = 100
        self.flameblinHead.alpha = 0
        self.flameblinHead.name = "flameblinHead"
        self.addChild(flameblinHead)
        
        self.flameblinCount.position = CGPoint(x: self.flameblinHead.position.x + self.flameblinHead.size.width/1.5,
                                               y: self.flameblinHead.position.y - self.flameblinHead.frame.maxY * 0.10)
        self.flameblinCount.zPosition = 100
        self.flameblinCount.alpha = 0
        self.flameblinCount.name = "flameblinCount"
        self.addChild(flameblinCount)
        
        self.rockHead.size = CGSize(width: self.size.width/2, height: self.size.width/4)
        self.rockHead.position = CGPoint(x: self.position.x + self.size.width + self.goblinHead.size.width/4,
                                         y: self.position.y + self.size.height/4)
        self.rockHead.color = .yellow
        self.rockHead.zPosition = 100
        self.rockHead.alpha = 0
        self.rockHead.name = "rockHead"
        self.addChild(rockHead)
        
        self.rockCount.position = CGPoint(x: self.rockHead.position.x + self.rockHead.size.width/1.5,
                                            y: self.rockHead.position.y - self.rockHead.frame.maxY * 0.10)
        self.rockCount.zPosition = 100
        self.rockCount.alpha = 0
        self.rockCount.name = "rockCount"
        self.addChild(rockCount)
        
        self.gumblingHead.size = CGSize(width: self.size.width/2, height: self.size.width/4)
        self.gumblingHead.position = CGPoint(x: self.position.x + self.size.width + self.gumblingHead.size.width/4,
                                             y: self.position.y - self.size.height/4)
        self.gumblingHead.color = .yellow
        self.gumblingHead.zPosition = 100
        self.gumblingHead.alpha = 0
        self.gumblingHead.name = "gumblingHead"
        self.addChild(gumblingHead)
        
        self.gumblingCount.position = CGPoint(x: self.gumblingHead.position.x + self.gumblingHead.size.width/1.5,
                                            y: self.gumblingHead.position.y + self.gumblingHead.frame.maxY * 0.30)
        self.gumblingCount.zPosition = 100
        self.gumblingCount.alpha = 0
        self.gumblingCount.name = "gumblingCount"
        self.addChild(gumblingCount)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCauldron(amount: Int){
        self.currentGoblinsNumber += amount
        self.currentGoblinsNumberLabel.text = String(self.currentGoblinsNumber) + "/" + String(self.maxGoblinNumber)
    }
    
    func spawnSelection(population: Population) {
    
        var flameblinCount = 0
        var rockCount = 0
        var gumblingCount = 0
        var normalCount = 0
        
        self.goblinHead.alpha = 1.0
        self.goblinCount.alpha = 1.0
        
        for i in 0..<population.goblins.count {
            if population.goblins[i].type == .fire {
                flameblinCount += 1
                self.flameblinHead.alpha = 1.0
                self.flameblinCount.alpha = 1.0
            }
            if population.goblins[i].type == .rock {
                rockCount += 1
                self.rockHead.alpha = 1.0
                self.rockCount.alpha = 1.0
            }
            if population.goblins[i].type == .gum {
                gumblingCount += 1
                self.gumblingHead.alpha = 1.0
                self.gumblingCount.alpha = 1.0
            }
            if population.goblins[i].type == .normal {
                normalCount += 1
            }
        }
        
        self.goblinCount.text = String(normalCount)
        self.rockCount.text = String(rockCount)
        self.flameblinCount.text = String(flameblinCount)
        self.gumblingCount.text = String(gumblingCount)

    }
    
    func closeSpawn(){
        self.goblinHead.alpha = 0.0
        self.goblinCount.alpha = 0.0
        self.flameblinHead.alpha = 0.0
        self.flameblinCount.alpha = 0.0
        self.rockHead.alpha = 0.0
        self.rockCount.alpha = 0.0
        self.gumblingHead.alpha = 0.0
        self.gumblingCount.alpha = 0.0
    }
}
