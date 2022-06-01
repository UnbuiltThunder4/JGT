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
        super.init(texture: SKTexture(imageNamed: "structure sheet wide"), color: .yellow, size: CGSize(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.height/1.8))
        self.name = "scrollableMenu"
        
        self.nameLabel.name = "scrollableName"
        self.addChild(nameLabel)
        self.descLabel.name = "scrollableDesc"
        self.addChild(descLabel)
        self.addChild(goblinTable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMenu(structure: Structure){
        self.alpha = 1.0
        self.nameLabel.text = structure.name
        self.descLabel.text = structure.name
        for i in 0..<structure.goblins.count {
            goblinTable.addRow(row: GoblinRow(goblinFaceTexture: SKTexture(imageNamed: "normalHead"), goblinNameText: structure.goblins[i].fullName, goblinStatsText: String(structure.goblins[i].age)))
        }
        print(structure.goblins.count)
        print(structure.name)
    }
}

class GoblinTable: SKNode {
    
    @Published public var rows: [GoblinRow] = []
    
    override init() {
//        super.init(texture: SKTexture(imageNamed: "structures sheet"), color: .yellow, size: CGSize())
        super.init()
        self.name = "table"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRow(row: GoblinRow) {
        let lastRowPosition = getLastRowPosition()
        row.position.y = lastRowPosition.y - row.frame.height/2
        rows.append(row)
        row.name = "row"
        self.addChild(row)
    }
    
    func deleteRow(row: GoblinRow) {
        let index = self.rows.firstIndex(where: { $0.id == row.id })
        self.rows[index!].removeFromParent()
        self.rows.remove(at: index!)
        shiftRows(rowHeight: row.frame.height, index: (index)!)
    }
    
    func shiftRows(rowHeight: CGFloat, index: Int) {
        for i in index..<self.rows.count - 1{
            self.rows[i].position.y += rowHeight/2
        }
    }
    
    func getLastRowPosition() -> CGPoint {
        if let position = self.rows.last?.position {
            return position
        } else {
            return CGPoint(x: 0, y: 0)
        }
    }
}

class GoblinRow: SKSpriteNode, Identifiable, ObservableObject {
    
    public let id = UUID()
    
    var goblinFace: SKSpriteNode = SKSpriteNode()
    var goblinName: SKLabelNode = SKLabelNode()
    var goblinStats: SKLabelNode = SKLabelNode()
    
    init(goblinFaceTexture: SKTexture, goblinNameText: String, goblinStatsText: String) {
        self.goblinFace.texture = SKTexture(imageNamed: "normalHead")
        self.goblinFace.name = "goblinFace"
        self.goblinName.name = "goblinName"
        self.goblinStats.name = "goblinStats"
        
        super.init(texture: SKTexture(imageNamed: "gauge"), color: .yellow, size: CGSize(width: 200, height: 50))
        
        self.addChild(goblinFace)
        self.addChild(goblinName)
        self.addChild(goblinStats)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
