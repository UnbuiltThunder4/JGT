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
        
        self.healthLabel.alpha = 1.0
        self.attackLabel.alpha = 1.0
        self.typeLabel.alpha = 1.0
        self.fearLabel.alpha = 1.0
        self.ageLabel.alpha = 1.0
        self.witLabel.alpha = 1.0
        self.frenzyLabel.alpha = 1.0
        
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
        
        self.texture = SKTexture(imageNamed: "sheet")
        self.size = HUDSettings.sheetSize
        
        self.nameLabel.position = CGPoint(x: self.frame.maxX * -0.08,
                                           y: self.frame.maxY * 0.55)
        self.typeLabel.position = CGPoint(x: ((UIDevice.current.userInterfaceIdiom == .pad) ? self.frame.maxX * -0.233 : self.frame.maxX * -0.22),
                                           y: self.frame.maxY * 0.40)
        self.descLabel.position = CGPoint(x: 0,
                                           y: self.frame.minY * 0.08)
        self.healthLabel.position = CGPoint(x: self.frame.maxX * -0.037, y: self.frame.maxY * 0.3)
        self.attackLabel.position = CGPoint(x: self.frame.maxX * 0.1, y: self.frame.maxY * 0.3)
        self.fearLabel.position = CGPoint(x: self.frame.maxX * 0.23, y: self.frame.maxY * 0.3)
        self.ageLabel.position = CGPoint(x: self.frame.maxX * -0.037, y: self.frame.maxY * 0.18)
        self.witLabel.position = CGPoint(x: self.frame.maxX * 0.1, y: self.frame.maxY * 0.18)
        self.frenzyLabel.position = CGPoint(x: self.frame.maxX * 0.23, y: self.frame.maxY * 0.18)
        
        self.nameLabel.fontColor = HUDSettings.nameFontColor
        
        nameLabel.text = goblin.fullName
        descLabel.text = goblin.backstory
        healthLabel.text = "\(String(goblin.health))/\(String(goblin.maxHealth))"
        attackLabel.text = "\(String(goblin.attack))"
        fearLabel.text = "\(String(goblin.fear))%"
        ageLabel.text = "\(String(goblin.age))"
        witLabel.text = "\(String(Int(goblin.HWpoints)/(goblin.age+1)))"
        frenzyLabel.text = "\(String(goblin.frenzy))"
    }
    
    func updateSheet(enemy: Enemy) {
        
        self.healthLabel.alpha = 0.0
        self.attackLabel.alpha = 0.0
        self.fearLabel.alpha = 0.0
        self.ageLabel.alpha = 0.0
        self.witLabel.alpha = 0.0
        self.frenzyLabel.alpha = 0.0
        self.typeLabel.alpha = 0.0
        self.nameLabel.text = enemy.fullName
        self.nameLabel.fontColor = .white
        self.descLabel.text = enemy.desc

        self.texture = SKTexture(imageNamed: "structure sheet wide")
        self.size = UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: UIScreen.main.bounds.width/2.7, height: UIScreen.main.bounds.height/1.6) : CGSize(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.height/1.8)
        
        self.nameLabel.verticalAlignmentMode = .center
        self.descLabel.verticalAlignmentMode = .top
        
        self.nameLabel.position = CGPoint(x: -self.frame.maxX * 0.1,
                                           y: self.frame.maxY * 0.75)
        self.descLabel.position = CGPoint(x: 0, y: self.frame.maxY * 0.55)
        
        
    }
    
    func updateSheet(darkSon: DarkSon) {
        self.healthLabel.alpha = 0.0
        self.attackLabel.alpha = 0.0
        self.fearLabel.alpha = 0.0
        self.ageLabel.alpha = 0.0
        self.witLabel.alpha = 0.0
        self.frenzyLabel.alpha = 0.0
        self.typeLabel.alpha = 0.0
        self.nameLabel.text = "Dark Son"
        self.nameLabel.fontColor = .white
        self.descLabel.text = darkSon.desc
        self.typeLabel.texture = SKTexture(imageNamed: "dark-son-lives")
        
        self.texture = SKTexture(imageNamed: "structure sheet wide")
        self.size = UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: UIScreen.main.bounds.width/2.7, height: UIScreen.main.bounds.height/1.6) : CGSize(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.height/1.8)
        
        self.nameLabel.verticalAlignmentMode = .center
        self.descLabel.verticalAlignmentMode = .top
        
        self.nameLabel.position = CGPoint(x: -self.frame.maxX * 0.1,
                                           y: self.frame.maxY * 0.75)
        self.descLabel.position = CGPoint(x: 0,
                                                    y: self.frame.maxY * 0.55)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
