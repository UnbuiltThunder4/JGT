//
//  ScrollableMenu.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 01/06/22.
//

import Foundation
import SpriteKit
import SwiftUI

class ScrollableMenu: SKSpriteNode, ObservableObject {
    static let shared: ScrollableMenu = ScrollableMenu()
    
    var nameLabel: SKLabelNode = SKLabelNode()
    var descLabel: SKLabelNode = SKLabelNode()
    var goblinTable: GoblinTable = GoblinTable()
    var currentStructure: String = ""
    var contentSection: CGFloat = 0.0
    var tableSize: CGFloat = 0.0
    var rowsSize: CGSize = CGSize()
    var sheetWidth: CGFloat = CGFloat()
    var sheetHeight: CGFloat = CGFloat()
    
    init() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            sheetWidth = UIScreen.main.bounds.width/3
            sheetHeight = UIScreen.main.bounds.height/1.5
            break
        case .pad:
            sheetWidth = UIScreen.main.bounds.width/2.5
            sheetHeight = UIScreen.main.bounds.height/1.8
            break
        @unknown default:
            break
        }
        
        super.init(texture: SKTexture(imageNamed: "structure sheet wide"), color: .yellow, size: CGSize(width: sheetWidth, height: sheetHeight))
        
        self.name = "scrollableMenu"
        
        self.contentSection = self.frame.minY/2
        
        self.rowsSize = CGSize(width: self.frame.width/1.2, height: self.frame.height/10)
        
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
        self.alpha = 1.0
        self.nameLabel.text = structure.fullName
        self.descLabel.text = structure.desc
        
        if structure.type == .tavern || structure.type == .academy || structure.type == .village {
        for i in 0..<structure.goblins.count {
            goblinTable.addRow(row: GoblinRow(goblin: structure.goblins[i]))
            self.tableSize += self.goblinTable.rows[i].frame.height
        }
        self.hideRow()
        }
        else {
        }
    }
    
    func closeMenu() {
        self.goblinTable.clearRows()
        self.goblinTable.lastRowPosition = self.goblinTable.initialRowPosition
        self.goblinTable.position = CGPoint.zero
        self.goblinTable.contentOffset = 0.0
        self.tableSize = 0.0
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

class GoblinTable: SKNode, ObservableObject {
    
    @Published public var rows: [GoblinRow] = []
    let initialRowPosition = CGPoint.zero
    var lastRowPosition = CGPoint()
    var contentOffset = 0.0
    var firstRow: GoblinRow?
    var lastRow: GoblinRow?
    
    override init() {
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
    @ObservedObject var scrollableMenu: ScrollableMenu = ScrollableMenu.shared

    public let id = UUID()
    
    var goblinID: UUID = UUID()
    var goblinFace: SKSpriteNode = SKSpriteNode(imageNamed: "normalHead")
    var goblinName: SKLabelNode = SKLabelNode()
    var goblinStats: SKLabelNode = SKLabelNode()
    
    init(goblin: Goblin) {
        self.goblinFace.name = "goblinFace"
        self.goblinName.name = "goblinName"
        self.goblinStats.name = "goblinStats"
        
        super.init(texture: SKTexture(imageNamed: "gauge"), color: .yellow, size: CGSize())
        
        self.size = CGSize(width: scrollableMenu.rowsSize.width, height: scrollableMenu.rowsSize.height)
        
        self.goblinID = goblin.id
        self.goblinName.text = goblin.fullName
        self.goblinStats.text = String(goblin.currentFrenzyTurn)
        
        switch goblin.type {
        case .normal:
            self.goblinFace.texture = SKTexture(imageNamed: "normalHead")
            break
        case .fire:
            self.goblinFace.texture = SKTexture(imageNamed: "fireHead")
            break
        case .rock:
            self.goblinFace.texture = SKTexture(imageNamed: "rockHead")
            break
        case .gum:
            self.goblinFace.texture = SKTexture(imageNamed: "gumHead")
            break
        }
        
        self.goblinFace.setScale(0.1)
        self.goblinFace.position.x = self.frame.minX + goblinFace.size.width
        
        self.goblinName.fontName = HUDSettings.nameFont
        self.goblinName.fontSize = HUDSettings.nameFontSize
        self.goblinName.fontColor = HUDSettings.fontColor
        self.goblinName.position = CGPoint(x: self.frame.minX + goblinName.frame.width, y: self.frame.midY)
        self.goblinName.verticalAlignmentMode = .center
        self.goblinName.horizontalAlignmentMode = .center
        
        self.goblinStats.fontName = HUDSettings.nameFont
        self.goblinStats.fontSize = HUDSettings.statsFontSize
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
