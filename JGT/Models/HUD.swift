//
//  HUD.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SpriteKit
import Foundation

enum HUDSettings {
    static let font = "Noteworthy-Bold"
    static let fontSize: CGFloat = 10
    static let fontColor: UIColor = .red
}

class HUD: SKNode {
    
    override init() {
        super.init()
        name = "HUD"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addCauldron(cauldron: Cauldron, position: CGPoint) {
        
        cauldron.zPosition = 100
        addChild(cauldron)
        cauldron.position = position
        
        cauldron.currentGoblinsNumberLabel.fontName = HUDSettings.font
        cauldron.currentGoblinsNumberLabel.fontSize = HUDSettings.fontSize
        cauldron.currentGoblinsNumberLabel.fontColor = HUDSettings.fontColor
        
        cauldron.currentGoblinsNumberLabel.text = String(cauldron.currentGoblinsNumber) + "/" + String(cauldron.maxGoblinNumber)
        
    }
    
    func addSheet(sheet: Sheet, position: CGPoint) {
    
        sheet.alpha = 0.0
        sheet.zPosition = 100
        addChild(sheet)
        sheet.position = position
        
        sheet.nameLabel.fontName = HUDSettings.font
        sheet.typeLabel.fontName = HUDSettings.font
        sheet.descLabel.fontName = HUDSettings.font
        sheet.statLabel.fontName = HUDSettings.font
        
        sheet.nameLabel.fontSize = HUDSettings.fontSize
        sheet.typeLabel.fontSize = HUDSettings.fontSize
        sheet.descLabel.fontSize = HUDSettings.fontSize
        sheet.statLabel.fontSize = HUDSettings.fontSize
        
        sheet.nameLabel.fontColor = HUDSettings.fontColor
        sheet.typeLabel.fontColor = HUDSettings.fontColor
        sheet.descLabel.fontColor = HUDSettings.fontColor
        sheet.statLabel.fontColor = HUDSettings.fontColor
        
        sheet.nameLabel.position = CGPoint(x: 0,
                                           y: sheet.frame.maxY - 20)
        sheet.typeLabel.position = CGPoint(x: 0,
                                           y: sheet.frame.maxY/1.4)
        sheet.descLabel.position = CGPoint(x: 0,
                                           y: sheet.frame.maxY / 1.5)
        sheet.statLabel.position = CGPoint(x: 0,
                                           y: sheet.frame.maxY / 20.0 - 50)
        
        sheet.nameLabel.verticalAlignmentMode = .center
        sheet.descLabel.verticalAlignmentMode = .top
        sheet.descLabel.preferredMaxLayoutWidth = sheet.frame.width - 20
        sheet.descLabel.numberOfLines = Int(sheet.descLabel.frame.width / sheet.frame.width)
        
        sheet.statLabel.numberOfLines = 5
        
    }
    
    func addEvilGauge(evilGauge: EvilGauge, position: CGPoint) {
        evilGauge.position = position
        addChild(evilGauge)
        evilGauge.zPosition = 100
    }

}
