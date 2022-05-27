//
//  StructureModel.swift
//  JGT
//
//  Created by Eugenio Raja on 09/05/22.
//

import Foundation
import SwiftUI
import SpriteKit

class Structure: SKSpriteNode, ObservableObject {
    var goblins: [Goblin] = []
    let type: StructureType
    let mask: Collision.Masks
    let maskmod: CGFloat
    let width: CGFloat
    let height: CGFloat
    
    init(type: StructureType, x: CGFloat, y: CGFloat, rotation: Double) {
        var img = ""
        self.type = type
        switch type {
            
        case .gate:
            img = "gate"
            self.mask = .gate
            self.width = 380
            self.height = 380
            self.maskmod = 1.3
            break
            
        case .backdoor:
            img = "backdoor"
            self.mask = .enviroment
            self.width = 125
            self.height = 150
            self.maskmod = 1.3
            break
            
        case .academy:
            img = "academy"
            self.mask = .building
            self.width = 300
            self.height = 300
            self.maskmod = 0.9
            break
            
        case .tavern:
            img = "tavern"
            self.mask = .building
            self.width = 300
            self.height = 300
            self.maskmod = 0.9
            break
            
        case .village:
            img = "village"
            self.mask = .building
            self.width = 300
            self.height = 300
            self.maskmod = 0.9
            break
            
        case .catapult:
            img = "catapult"
            self.mask = .enviroment
            self.width = 250
            self.height = 250
            self.maskmod = 0.9
            break
            
        case .wall:
            img = "wall"
            self.mask = .building
            self.width = 1700
            self.height = 700
            self.maskmod = 1.0
            break
        
        case .tree:
            img = "tree"
            self.mask = .enviroment
            self.width = 150
            self.height = 300
            self.maskmod = 1.3
            break
            
        case .rock:
            img = "rock"
            self.mask = .enviroment
            self.width = 80
            self.height = 80
            self.maskmod = 1.5
            break
            
        default:
            img = "rock"
            self.mask = .enviroment
            self.width = 300
            self.height = 300
            self.maskmod = 1.2
            break
        }
        super.init(texture: SKTexture(imageNamed: img), color: .red, size: CGSize(width: self.width, height: self.height))
        self.name = img
        self.position.x = x
        self.position.y = y
        self.zRotation = rotation
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addGoblin(_ goblin: Goblin) {
    }
    
    public func removeGoblin(_ goblin: Goblin) {
    }
}

class Tavern: Structure {
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .tavern, x: x, y: y, rotation: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addGoblin(_ goblin: Goblin) {
        self.goblins.append(goblin)
    }
    
    override func removeGoblin(_ goblin: Goblin) {
        if let index = self.goblins.firstIndex(where: { $0.id == goblin.id }) {
            self.goblins.remove(at: index)
        }
    }
}

class Academy: Structure {
    var proficencies: [Proficency] = []
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .academy, x: x, y: y, rotation: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addGoblin(_ goblin: Goblin) {
        self.goblins.append(goblin)
    }
    
    override func removeGoblin(_ goblin: Goblin) {
        if let index = self.goblins.firstIndex(where: { $0.id == goblin.id }) {
            self.goblins.remove(at: index)
        }
    }
}

class Village: Structure {
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .village, x: x, y: y, rotation: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addGoblin(_ goblin: Goblin) {
        self.goblins.append(goblin)
    }
    
    override func removeGoblin(_ goblin: Goblin) {
        if let index = self.goblins.firstIndex(where: { $0.id == goblin.id }) {
            self.goblins.remove(at: index)
        }
    }
}

class Catapult: Structure {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var hasRock: Bool = false
//    let attackPosition = CGPoint(x: 1200, y: 1200)
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .catapult, x: x, y: y, rotation: 0)
//        self.speed = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(_ tossScene: TossScene) {
        if (self.hasRock) {
            gameLogic.spawnProjectile(tossScene, spawnPoint: CGPoint(x: self.position.x, y: self.position.y), destinationPoint: CGPoint(x: self.position.x + 500, y: self.position.y + 500), type: .rock)
            self.hasRock = false
        }
    }
    
//    override func addGoblin(_ goblin: Goblin) {
//        self.goblins.append(goblin)
//    }
//
//    override func removeGoblin(_ goblin: Goblin) {
//        if let index = self.goblins.firstIndex(where: { $0.id == goblin.id }) {
//            self.goblins.remove(at: index)
//        }
//    }
}

class Gate: Structure {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var health: Int = 40
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .gate, x: x, y: y, rotation: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(_ tossScene: TossScene) {
        if (self.health <= 0) {
            self.removeFromParent()
            tossScene.darkson.gateNumber += 1
            tossScene.darkson.target = nil
        }
    }
}

class Backdoor: Structure {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var health: Int = 600
    var isOpened: Bool = false
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .backdoor, x: x, y: y, rotation: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(_ tossScene: TossScene) {
        print(self.health)
        if (self.health <= 0) {
            self.isOpened = true
            self.texture = SKTexture(imageNamed: "backdoor-open")
        }
    }
}
