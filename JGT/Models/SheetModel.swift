//
//  SheetModel.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 13/05/22.
//

import Foundation
import SpriteKit

class Sheet: SKSpriteNode {
    
    var nameLabel: SKLabelNode
    var typeLabel: SKSpriteNode
    var descLabel: SKLabelNode
    var healthLabel: SKLabelNode
    var attackLabel: SKLabelNode
    var fearLabel: SKLabelNode
    var ageLabel: SKLabelNode
    var witLabel: SKLabelNode
    var frenzyLabel: SKLabelNode
    
    init() {
        self.nameLabel = SKLabelNode()
        self.nameLabel.name = "name"
        self.typeLabel = SKSpriteNode(imageNamed: "normalHead")
        self.typeLabel.setScale(0.25)
        self.typeLabel.name = "type"
        self.descLabel = SKLabelNode()
        self.descLabel.name = "description"
        self.healthLabel = SKLabelNode()
        self.healthLabel.name = "health"
        self.attackLabel = SKLabelNode()
        self.attackLabel.name = "attack"
        self.fearLabel = SKLabelNode()
        self.fearLabel.name = "fear"
        self.ageLabel = SKLabelNode()
        self.ageLabel.name = "age"
        self.witLabel = SKLabelNode()
        self.witLabel.name = "wit"
        self.frenzyLabel = SKLabelNode()
        self.frenzyLabel.name = "frenzy"
        
        super.init(texture: SKTexture(imageNamed: "sheet"), color: .red, size: CGSize(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.height/1.8))
                
        self.name = "sheet"
        
        self.addChild(nameLabel)
        self.addChild(typeLabel)
        self.addChild(descLabel)
        self.addChild(healthLabel)
        self.addChild(attackLabel)
        self.addChild(fearLabel)
        self.addChild(ageLabel)
        self.addChild(witLabel)
        self.addChild(frenzyLabel)

    }
    
    func updateSheet(goblin: Goblin) {
        switch goblin.type {
        case .normal:
            typeLabel.texture = SKTexture(imageNamed: "normalHead")
            break
        case.fire:
            typeLabel.texture = SKTexture(imageNamed: "fireHead")
            break
        case.rock:
            typeLabel.texture = SKTexture(imageNamed: "rockHead")
            break
        case.gum:
            typeLabel.texture = SKTexture(imageNamed: "gumHead")
            break
        }
        
        nameLabel.text = goblin.fullName
        descLabel.text = goblin.backstory
        healthLabel.text = "\(String(goblin.health))/\(String(goblin.maxHealth))"
        attackLabel.text = "\(String(goblin.attack))"
        fearLabel.text = "\(String(goblin.fear))%"
        ageLabel.text = "\(String(goblin.age))"
        witLabel.text = "\(String(Int(goblin.HWpoints)/(goblin.age+1)))"
        frenzyLabel.text = "\(String(goblin.frenzy))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
