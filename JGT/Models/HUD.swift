//
//  HUD.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SpriteKit
import Foundation

enum HUDSettings {
    static var sheetSize = CGSize()
    static var font = "Noteworthy-Bold"
    static var fontSize: CGFloat = 25
    static var statsFontSize: CGFloat = 14
    static var fontColor: UIColor = .red
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
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            HUDSettings.sheetSize = CGSize(width: 320, height: 340)
            HUDSettings.fontSize = 25
            HUDSettings.statsFontSize = 14
            break
        case .pad:
            HUDSettings.sheetSize = CGSize(width: 550, height: 620)
            HUDSettings.fontSize = 25
            HUDSettings.statsFontSize = 14
            break
        @unknown default:
            break
        }
        sheet.alpha = 0.0
        sheet.zPosition = 100
        addChild(sheet)
        sheet.position = position
        
        sheet.size = HUDSettings.sheetSize
        
        sheet.nameLabel.fontName = HUDSettings.font
//        sheet.typeLabel.fontName = HUDSettings.font
        sheet.descLabel.fontName = HUDSettings.font
        
        sheet.healthLabel.fontName = HUDSettings.font
        sheet.attackLabel.fontName = HUDSettings.font
        sheet.fearLabel.fontName = HUDSettings.font
        sheet.ageLabel.fontName = HUDSettings.font
        sheet.witLabel.fontName = HUDSettings.font
        sheet.frenzyLabel.fontName = HUDSettings.font

        
        sheet.nameLabel.fontSize = HUDSettings.fontSize
//        sheet.typeLabel.fontSize = HUDSettings.fontSize
        sheet.descLabel.fontSize = HUDSettings.fontSize
        
        sheet.healthLabel.fontSize = HUDSettings.statsFontSize
        sheet.attackLabel.fontSize = HUDSettings.statsFontSize
        sheet.fearLabel.fontSize = HUDSettings.statsFontSize
        sheet.ageLabel.fontSize = HUDSettings.statsFontSize
        sheet.witLabel.fontSize = HUDSettings.statsFontSize
        sheet.frenzyLabel.fontSize = HUDSettings.statsFontSize
        
        sheet.nameLabel.fontColor = HUDSettings.fontColor
//        sheet.typeLabel.fontColor = HUDSettings.fontColor
        sheet.descLabel.fontColor = HUDSettings.fontColor
        sheet.healthLabel.fontColor = HUDSettings.fontColor
        sheet.attackLabel.fontColor = HUDSettings.fontColor
        sheet.fearLabel.fontColor = HUDSettings.fontColor
        sheet.ageLabel.fontColor = HUDSettings.fontColor
        sheet.witLabel.fontColor = HUDSettings.fontColor
        sheet.frenzyLabel.fontColor = HUDSettings.fontColor
        
        
        sheet.nameLabel.position = CGPoint(x: sheet.frame.maxX * -0.08,
                                           y: sheet.frame.maxY * 0.55)
        sheet.typeLabel.position = CGPoint(x: sheet.frame.maxX * -0.23,
                                           y: sheet.frame.maxY * 0.42)
        sheet.descLabel.position = CGPoint(x: 0,
                                           y: sheet.frame.minY * 0.08)
//        sheet.statLabel.position = CGPoint(x: 0,
//                                           y: sheet.frame.maxY / 20.0 - 50)
        sheet.healthLabel.position = CGPoint(x: sheet.frame.maxX * -0.037, y: sheet.frame.maxY * 0.3)
        sheet.attackLabel.position = CGPoint(x: sheet.frame.maxX * 0.1, y: sheet.frame.maxY * 0.3)
        sheet.fearLabel.position = CGPoint(x: sheet.frame.maxX * 0.23, y: sheet.frame.maxY * 0.3)
        sheet.ageLabel.position = CGPoint(x: sheet.frame.maxX * -0.037, y: sheet.frame.maxY * 0.18)
        sheet.witLabel.position = CGPoint(x: sheet.frame.maxX * 0.1, y: sheet.frame.maxY * 0.18)
        sheet.frenzyLabel.position = CGPoint(x: sheet.frame.maxX * 0.23, y: sheet.frame.maxY * 0.18)

        sheet.nameLabel.horizontalAlignmentMode = .left
        sheet.healthLabel.horizontalAlignmentMode = .left
        sheet.attackLabel.horizontalAlignmentMode = .left
        sheet.fearLabel.horizontalAlignmentMode = .left
        sheet.ageLabel.horizontalAlignmentMode = .left
        sheet.witLabel.horizontalAlignmentMode = .left
        sheet.frenzyLabel.horizontalAlignmentMode = .left
        
        sheet.nameLabel.verticalAlignmentMode = .center
        sheet.descLabel.verticalAlignmentMode = .top
        sheet.descLabel.preferredMaxLayoutWidth = sheet.frame.width - sheet.frame.width/6
        sheet.descLabel.numberOfLines = Int(sheet.descLabel.frame.width / sheet.frame.width)
//        sheet.healthLabel.fontColor = HUDSettings.fontColor
//        sheet.attackLabel.fontColor = HUDSettings.fontColor
//        sheet.fearLabel.fontColor = HUDSettings.fontColor
//        sheet.ageLabel.fontColor = HUDSettings.fontColor
//        sheet.witLabel.fontColor = HUDSettings.fontColor
//        sheet.frenzyLabel.fontColor = HUDSettings.fontColor
//        sheet.statLabel.verticalAlignmentMode = .center
        
    }
    
    func addEvilGauge(evilGauge: EvilGauge, position: CGPoint) {
        evilGauge.position = position
        addChild(evilGauge)
        evilGauge.zPosition = 100
    }

}
