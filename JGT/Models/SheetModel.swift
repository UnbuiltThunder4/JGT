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
    var typeLabel: SKLabelNode
    var descLabel: SKLabelNode
    var statLabel: SKLabelNode
    
    init() {
        self.nameLabel = SKLabelNode()
        self.typeLabel = SKLabelNode()
        self.descLabel = SKLabelNode()
        self.statLabel = SKLabelNode()
        super.init(texture: SKTexture(imageNamed: "sheet"), color: .red, size: CGSize(width: 550, height: 620))
        self.name = "sheet"
        
        self.addChild(nameLabel)
        self.addChild(typeLabel)
        self.addChild(descLabel)
        self.addChild(statLabel)
    }
    
    func updateSheet(goblin: Goblin) {
        
        var goblinType = ""
        
        switch goblin.type {
        case .normal:
            goblinType = "Base Goblin"
            break
        case.fire:
            goblinType = "Flembling"
            break
        case.rock:
            goblinType = "Rock Goblin"
            break
        case.gum:
            goblinType = "Gumbling"
            break
        }
        
        nameLabel.text = goblin.fullName
        typeLabel.text = goblinType
        descLabel.text = goblin.backstory
        statLabel.text = """
                            HP: \(String(goblin.health))/\(String(goblin.maxHealth))
                            ATK: \(String(goblin.attack))
                            FER: \(String(goblin.fear))
                            FRZ: \(String(goblin.frenzy))
                            AGE: \(String(goblin.age))
                         """
    }
    
    func updateSheet(structure: Structure) {
        
        nameLabel.text = structure.name
        typeLabel.text = ""
        descLabel.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
