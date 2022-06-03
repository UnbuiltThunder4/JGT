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
    @ObservedObject var scrollableMenu: ScrollableMenu = ScrollableMenu.shared

    var goblins: [Goblin] = []
    let type: StructureType
    let mask: Collision.Masks
    let maskmodX: CGFloat
    let maskmodY: CGFloat
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
            self.maskmodX = 1.0
            self.maskmodY = 1.3
            break
            
        case .backdoor:
            img = "backdoor"
            self.mask = .enviroment
            self.width = 125
            self.height = 150
            self.maskmodX = 0.7
            self.maskmodY = 1.0
            break
            
        case .passage:
            img = "backdoor-up"
            self.mask = .enviroment
            self.width = 125
            self.height = 75
            self.maskmodX = 0.5
            self.maskmodY = 0.6
            break
            
        case .trap:
            img = "open-trap"
            self.mask = .enviroment
            self.width = 80
            self.height = 80
            self.maskmodX = 0.2
            self.maskmodY = 0.2
            break
            
        case .academy:
            img = "academy"
            self.mask = .building
            self.width = 400
            self.height = 400
            self.maskmodX = 0.9
            self.maskmodY = 0.9
            break
            
        case .tavern:
            img = "tavern"
            self.mask = .building
            self.width = 400
            self.height = 400
            self.maskmodX = 0.9
            self.maskmodY = 0.9
            break
            
        case .village:
            img = "village"
            self.mask = .building
            self.width = 400
            self.height = 400
            self.maskmodX = 0.9
            self.maskmodY = 0.9
            break
            
        case .catapult:
            img = "catapult"
            self.mask = .enviroment
            self.width = 250
            self.height = 250
            self.maskmodX = 0.9
            self.maskmodY = 0.9
            break
            
        case .wall:
            img = "wall"
            self.mask = .building
            self.width = 1700
            self.height = 700
            self.maskmodX = 1.0
            self.maskmodY = 0.7
            break
        
        case .tree:
            img = "tree"
            self.mask = .enviroment
            self.width = 150
            self.height = 300
            self.maskmodX = 1.3
            self.maskmodY = 1.3
            break
            
        case .rock:
            img = "rock"
            self.mask = .enviroment
            self.width = 80
            self.height = 80
            self.maskmodX = 1.5
            self.maskmodY = 1.5
            break
            
        default:
            img = "rock"
            self.mask = .enviroment
            self.width = 300
            self.height = 300
            self.maskmodX = 1.1
            self.maskmodY = 1.1
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
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .tavern, x: x, y: y, rotation: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addGoblin(_ goblin: Goblin) {
        self.goblins.append(goblin)
        scrollableMenu.goblinTable.addRow(row: GoblinRow(goblin: goblin))
        scrollableMenu.rowsSize += 40.0
        scrollableMenu.hideRow()
    }
    
    override func removeGoblin(_ goblin: Goblin) {
        if let index = self.goblins.firstIndex(where: { $0.id == goblin.id }) {
            if let scrollIndex = scrollableMenu.goblinTable.rows.firstIndex(where: { $0.goblinID == goblin.id }) {
                scrollableMenu.goblinTable.deleteRow(row: scrollableMenu.goblinTable.rows[scrollIndex], structure: self)
            }
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
        if (!goblin.Proficiencies.isEmpty && !self.proficencies.isEmpty) {
            for i in 0..<goblin.Proficiencies.count {
                for j in 0..<self.proficencies.count {
                    if (self.proficencies[j]<goblin.Proficiencies[i]) {
                        self.proficencies.remove(at: j)
                        self.proficencies.append(goblin.Proficiencies[i])
                    }
                    else if (!self.proficencies.contains(goblin.Proficiencies[i])){
                        self.proficencies.append(goblin.Proficiencies[i])
                    }
                }
            }
        }
    }
    
    override func removeGoblin(_ goblin: Goblin) {
        if let index = self.goblins.firstIndex(where: { $0.id == goblin.id }) {
            if let scrollIndex = scrollableMenu.goblinTable.rows.firstIndex(where: { $0.goblinID == goblin.id }) {
                scrollableMenu.goblinTable.deleteRow(row: scrollableMenu.goblinTable.rows[scrollIndex], structure: self)
            }
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
        scrollableMenu.goblinTable.addRow(row: GoblinRow(goblin: goblin))
        scrollableMenu.rowsSize += 40.0
        scrollableMenu.hideRow()
    }
    
    override func removeGoblin(_ goblin: Goblin) {
        if let index = self.goblins.firstIndex(where: { $0.id == goblin.id }) {
            if let scrollIndex = scrollableMenu.goblinTable.rows.firstIndex(where: { $0.goblinID == goblin.id }) {
                scrollableMenu.goblinTable.deleteRow(row: scrollableMenu.goblinTable.rows[scrollIndex], structure: self)
            }
            self.goblins.remove(at: index)
        }
    }
}

class Catapult: Structure {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var hasRock: Bool = false
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .catapult, x: x, y: y, rotation: 0)
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
        
    var health: Int = 600
    var isOpened: Bool = false
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .backdoor, x: x, y: y, rotation: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(_ tossScene: TossScene) {
        if (self.health <= 0) {
            self.isOpened = true
            self.texture = SKTexture(imageNamed: "backdoor-open")
        }
    }
}

class Trap: Structure {
        
    var isActive: Bool = false
    var counter: Int = 0
    let electricParticle = SKEmitterNode(fileNamed: "ElectricParticle")
    
    init(x: CGFloat, y: CGFloat) {
        super.init(type: .trap, x: x, y: y, rotation: 0)
        addParticle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(_ tossScene: TossScene) {
        if (self.isActive) {
            self.counter += 1
            if (self.counter % twentySeconds == 0) {
                self.counter = 0
                self.isActive = false
                let openTrap = SKAction.setTexture(SKTexture(imageNamed: "open-trap"))
                self.run(openTrap)
            }
        }
    }
    
    private func addParticle() {
        electricParticle!.position = CGPoint(x: 0, y: 0)
        electricParticle!.name = "electricParticle"
        self.addChild(electricParticle!)
        
        let pauseParticle = SKAction.fadeOut(withDuration: 1)
        let startParticle = SKAction.fadeIn(withDuration: 1)
        
        let sequence = SKAction.sequence([
            startParticle,
            .wait(forDuration: 1),
            pauseParticle,
            .wait(forDuration: 1),
        ])
        
        let infiniteSequence = SKAction.repeatForever(sequence)
        
        electricParticle!.run(infiniteSequence, withKey: "particle")
    }
}
