//
//  ScrollableMenu.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 01/06/22.
//

import Foundation
import SpriteKit

class ScrollableMenu: SKSpriteNode {
    var nameLabel: SKLabelNode = SKLabelNode()
    var descLabel: SKLabelNode = SKLabelNode()
    var goblinTable: GoblinTable = GoblinTable()
    init() {
        super.init(texture: SKTexture(imageNamed: "structures sheet wide"), color: .yellow, size: CGSize())
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkRows(table: GoblinTable){
        
    }
}

class GoblinTable: SKSpriteNode {
    
    var rows: [GoblinRow] = []
    
    init() {
        super.init(texture: SKTexture(imageNamed: "structures sheet"), color: .yellow, size: CGSize())
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRow(row: GoblinRow) {
        self.addChild(row)
        rows.append(row)
    }
    
    func deleteRow(row: GoblinRow) {
        let index = self.rows.firstIndex(where: { $0.id == row.id })
        self.rows[index!].removeFromParent()
        self.rows.remove(at: index!)
    }
    
    func shiftRows(rows: [GoblinRow]) {
        
    }
}

class GoblinRow: SKSpriteNode, Identifiable {
    
    public let id = UUID()
    
    var goblinFace: SKSpriteNode = SKSpriteNode()
    var goblinName: SKLabelNode = SKLabelNode()
    var goblinStats: SKLabelNode = SKLabelNode()
    
    init(goblinFace: SKSpriteNode, goblinName: SKLabelNode, goblinStats: SKLabelNode) {
        self.goblinFace.texture = SKTexture(imageNamed: "normalHead")
        self.goblinFace.name = "goblinFace"
        self.goblinName.name = "goblinName"
        self.goblinStats.name = "goblinStats"
        
        super.init(texture: SKTexture(imageNamed: "gauge"), color: .yellow, size: CGSize(width: 200, height: 50))
        
        self.goblinFace = goblinFace
        self.goblinName = goblinName
        self.goblinStats = goblinStats
        
        self.addChild(goblinFace)
        self.addChild(goblinName)
        self.addChild(goblinStats)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
