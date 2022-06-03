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
    var contentSection: CGFloat = 0.0
    var rowsSize: CGFloat = 0.0
    init() {
        super.init(texture: SKTexture(imageNamed: "structure sheet wide"), color: .yellow, size: CGSize(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.height/1.8))
        self.name = "scrollableMenu"
        
        self.contentSection = self.frame.minY/2
        
        self.nameLabel.name = "scrollableName"
        self.addChild(nameLabel)
        self.descLabel.name = "scrollableDesc"
        self.addChild(descLabel)
        self.addChild(goblinTable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openMenu(structure: Structure){
        var goblinTexture: SKTexture = SKTexture(imageNamed: "normalHead")
        self.alpha = 1.0
        self.nameLabel.text = structure.name
        self.descLabel.text = structure.name
        for i in 0..<structure.goblins.count {
            
            switch structure.goblins[i].type {
            case .normal:
                goblinTexture = SKTexture(imageNamed: "normalHead")
                break
            case .fire:
                goblinTexture = SKTexture(imageNamed: "fireHead")
                break
            case .rock:
                goblinTexture = SKTexture(imageNamed: "rockHead")
                break
            case .gum:
                goblinTexture = SKTexture(imageNamed: "gumHead")
                break
            }
            
            goblinTable.addRow(row: GoblinRow(goblinID: structure.goblins[i].id, goblinFaceTexture: goblinTexture, goblinNameText: structure.goblins[i].fullName, goblinStatsText: String(structure.goblins[i].age)))
            self.rowsSize += self.goblinTable.rows[i].frame.height
        }
        self.hideRow()
    }
    
    func closeMenu() {
        self.goblinTable.clearRows()
        self.goblinTable.lastRowPosition = self.goblinTable.initialRowPosition
        self.goblinTable.position = CGPoint.zero
        self.goblinTable.contentOffset = 0.0
        self.rowsSize = 0.0
    }
    
    func updateMenu(table: GoblinTable) {
        if table.rows.count > 0 {
            table.rows[0].position.y = 0
            for i in 1..<table.rows.count {
                table.rows[i].position.y = table.rows[i-1].position.y - table.rows[i].frame.height
            }
        }
    }
    
    func hideRow() {
        for i in 0..<self.goblinTable.rows.count {
            if self.goblinTable.rows[i].position.y + self.goblinTable.contentOffset > 0 ||
                self.goblinTable.rows[i].position.y + self.goblinTable.contentOffset < self.frame.minY/1.5 {
                self.goblinTable.rows[i].alpha = 0.0
            } else {
                self.goblinTable.rows[i].alpha = 1.0
            }
        }
    }
    
}

class GoblinTable: SKNode {
    
    @Published public var rows: [GoblinRow] = []
    let initialRowPosition = CGPoint.zero
    var lastRowPosition = CGPoint()
    var contentOffset = 0.0
    var firstRow: GoblinRow?
    var lastRow: GoblinRow?
    
    override init() {
        //        super.init(texture: SKTexture(imageNamed: "structures sheet"), color: .yellow, size: CGSize())
        super.init()
        self.name = "table"
        
        self.lastRowPosition = self.initialRowPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRow(row: GoblinRow) {
        self.lastRowPosition = getLastRowPosition()
        row.position.y = self.lastRowPosition.y - row.frame.height
        rows.append(row)
        row.name = "row"
        self.addChild(row)
    }
    
    func deleteRow(row: GoblinRow, structure: Structure) {
//        let strIndex = structure.goblins.firstIndex(where: { $0.id == row.goblinID})
//        structure.goblins[strIndex!].position.y = structure.position.y * 2
//        structure.goblins[strIndex!].state = .idle
//        structure.goblins[strIndex!].alpha = 1.0
//        structure.goblins.remove(at: strIndex!)
        let index = self.rows.firstIndex(where: { $0.id == row.id })
        self.rows[index!].removeFromParent()
        self.rows.remove(at: index!)
        row.removeFromParent()
        if index! != self.rows.endIndex {
            shiftRows(rowHeight: row.frame.height, index: (index)!)
        }
    }
    
    func shiftRows(rowHeight: CGFloat, index: Int) {
        for i in index..<self.rows.count{
            self.rows[i].position.y += rowHeight
        }
    }
    
    func clearRows() {
        self.removeAllChildren()
        self.rows.removeAll()
        self.lastRowPosition = self.initialRowPosition
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
    
    var goblinID: UUID = UUID()
    var goblinFace: SKSpriteNode = SKSpriteNode(imageNamed: "normalHead")
    var goblinName: SKLabelNode = SKLabelNode()
    var goblinStats: SKLabelNode = SKLabelNode()
    
    init(goblinID: UUID, goblinFaceTexture: SKTexture, goblinNameText: String, goblinStatsText: String) {
        self.goblinFace.name = "goblinFace"
        self.goblinName.name = "goblinName"
        self.goblinStats.name = "goblinStats"
        
        super.init(texture: SKTexture(imageNamed: "gauge"), color: .yellow, size: CGSize(width: 400, height: 40))
        
        self.goblinID = goblinID
        self.goblinFace.texture = goblinFaceTexture
        self.goblinName.text = goblinNameText
        self.goblinStats.text = goblinStatsText
        
        self.goblinFace.setScale(0.1)
        self.goblinFace.position.x = self.frame.minX + goblinFace.size.width
        
        self.goblinName.fontName = HUDSettings.font
        self.goblinName.fontSize = HUDSettings.fontSize
        self.goblinName.fontColor = HUDSettings.fontColor
        self.goblinName.position = CGPoint(x: self.frame.minX + goblinName.frame.width, y: self.frame.midY)
        self.goblinName.verticalAlignmentMode = .center
        self.goblinName.horizontalAlignmentMode = .center
        
        self.goblinStats.fontName = HUDSettings.font
        self.goblinStats.fontSize = HUDSettings.fontSize
        self.goblinStats.fontColor = HUDSettings.fontColor
        self.goblinStats.position = CGPoint(x: self.frame.maxX - goblinStats.frame.width, y: self.frame.midY)
        self.goblinStats.verticalAlignmentMode = .center
        
        self.addChild(goblinFace)
        self.addChild(goblinName)
        self.addChild(goblinStats)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
