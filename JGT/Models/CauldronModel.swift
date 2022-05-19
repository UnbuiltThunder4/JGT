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
    let goblinLabel: SKSpriteNode = SKSpriteNode(imageNamed: "normalHead")
    let flamblingLabel: SKSpriteNode = SKSpriteNode(imageNamed: "fireHead")
    let rockLabel: SKSpriteNode = SKSpriteNode(imageNamed: "rockHead")
    let gumblingLabel: SKSpriteNode = SKSpriteNode(imageNamed: "gumHead")
    var goblinCount: SKLabelNode = SKLabelNode()
    var flamblingCount: SKLabelNode = SKLabelNode()
    var rockCount: SKLabelNode = SKLabelNode()
    var gumblingCount: SKLabelNode = SKLabelNode()
    var currentGoblinsNumber: Int
    let maxGoblinNumber: Int
    
    init(currentGoblinsNumber: Int, maxGoblinNumber: Int) {
        
        self.currentGoblinsNumber = currentGoblinsNumber
        self.maxGoblinNumber = maxGoblinNumber
        
        super.init(texture: SKTexture(imageNamed: "cauldronn"), color: .red, size: CGSize(width: 70, height: 70))
        self.name = "cauldron"
        
        currentGoblinsNumberLabel.name = "goblinsNumber"
        currentGoblinsNumberLabel.position = CGPoint(x: 0, y: -self.size.height/4)
        currentGoblinsNumberLabel.isUserInteractionEnabled = false
        
        self.addChild(currentGoblinsNumberLabel)
        
        self.goblinLabel.position = CGPoint(x: self.position.x + self.goblinLabel.size.width/5, y: self.position.y)
        self.goblinLabel.setScale(0.2)
        self.goblinLabel.color = .green
        self.goblinLabel.zPosition = 100
        self.goblinLabel.alpha = 0
        self.goblinLabel.name = "normalLabel"
        self.addChild(goblinLabel)
        
        self.goblinCount.position = CGPoint(x: self.goblinLabel.position.x + 50, y: self.goblinLabel.position.y)
        self.goblinCount.zPosition = 100
        self.goblinCount.alpha = 0
        self.goblinCount.name = "goblinCount"
        self.addChild(goblinCount)
        
        self.flamblingLabel.position = CGPoint(x: self.position.x + self.flamblingLabel.size.width/5, y: self.position.y + 50)
        self.flamblingLabel.setScale(0.2)
        self.flamblingLabel.color = .red
        self.flamblingLabel.zPosition = 100
        self.flamblingLabel.alpha = 0
        self.flamblingLabel.name = "flamblingLabel"
        self.addChild(flamblingLabel)
        
        self.flamblingCount.position = CGPoint(x: self.flamblingLabel.position.x + 50, y: self.flamblingLabel.position.y)
        self.flamblingCount.zPosition = 100
        self.flamblingCount.alpha = 0
        self.flamblingCount.name = "flamblingCount"
        self.addChild(flamblingCount)
        
        self.rockLabel.position = CGPoint(x: self.position.x + self.rockLabel.size.width/5, y: self.position.y + 100)
        self.rockLabel.setScale(0.2)
        self.rockLabel.color = .yellow
        self.rockLabel.zPosition = 100
        self.rockLabel.alpha = 0
        self.rockLabel.name = "rockLabel"
        self.addChild(rockLabel)
        
        self.rockCount.position = CGPoint(x: self.rockLabel.position.x + 50, y: self.rockLabel.position.y)
        self.rockCount.zPosition = 100
        self.rockCount.alpha = 0
        self.rockCount.name = "rockCount"
        self.addChild(rockCount)
        
        self.gumblingLabel.position = CGPoint(x: self.position.x + self.gumblingLabel.size.width/5, y: self.position.y + 160)
        self.gumblingLabel.setScale(0.2)
        self.gumblingLabel.color = .yellow
        self.gumblingLabel.zPosition = 100
        self.gumblingLabel.alpha = 0
        self.gumblingLabel.name = "gumblingLabel"
        self.addChild(gumblingLabel)
        
        self.gumblingCount.position = CGPoint(x: self.gumblingLabel.position.x + 50, y: self.gumblingLabel.position.y)
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
    
        var flamblingCount = 0
        var rockCount = 0
        var gumblingCount = 0
        var normalCount = 0
        
        self.goblinLabel.alpha = 1.0
        self.goblinCount.alpha = 1.0
        
        print("cauldron")
        
        for i in 0..<population.goblins.count {
            if population.goblins[i].type == .fire {
                flamblingCount += 1
                self.flamblingLabel.alpha = 1.0
                self.flamblingCount.alpha = 1.0
            }
            if population.goblins[i].type == .rock {
                rockCount += 1
                self.rockLabel.alpha = 1.0
                self.rockCount.alpha = 1.0
            }
            if population.goblins[i].type == .gum {
                gumblingCount += 1
                self.gumblingLabel.alpha = 1.0
                self.gumblingCount.alpha = 1.0
            }
            if population.goblins[i].type == .normal {
                normalCount += 1
            }
        }
        
        self.goblinCount.text = String(normalCount)
        self.rockCount.text = String(rockCount)
        self.flamblingCount.text = String(flamblingCount)
        self.gumblingCount.text = String(gumblingCount)

    }
    
    func closeSpawn(){
        self.goblinLabel.alpha = 0.0
        self.goblinCount.alpha = 0.0
        self.flamblingLabel.alpha = 0.0
        self.flamblingCount.alpha = 0.0
        self.rockLabel.alpha = 0.0
        self.rockCount.alpha = 0.0
        self.gumblingLabel.alpha = 0.0
        self.gumblingCount.alpha = 0.0
    }
}
