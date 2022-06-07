//
//  HUD.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SpriteKit
import Foundation

enum HUDSettings {
    static var cauldronSize = CGSize()
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCauldron(cauldron: Cauldron, position: CGPoint) {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            HUDSettings.cauldronSize = CGSize(width: UIScreen.main.bounds.height/5.4, height: UIScreen.main.bounds.height/5.4)
            HUDSettings.fontSize = 13
            break
        case .pad:
            HUDSettings.cauldronSize = CGSize(width: UIScreen.main.bounds.height/6, height: UIScreen.main.bounds.height/6)
            break
        @unknown default:
            break
        }
        
        cauldron.size = HUDSettings.cauldronSize
        cauldron.zPosition = 100
        addChild(cauldron)
        cauldron.position = position
        
        cauldron.currentGoblinsNumberLabel.fontName = HUDSettings.font
        cauldron.currentGoblinsNumberLabel.fontSize = HUDSettings.fontSize
        cauldron.currentGoblinsNumberLabel.fontColor = HUDSettings.fontColor
        
        cauldron.goblinCount.fontName = HUDSettings.font
        cauldron.goblinCount.fontSize = HUDSettings.fontSize
        cauldron.goblinCount.fontColor = HUDSettings.fontColor
        cauldron.flameblinCount.fontName = HUDSettings.font
        cauldron.flameblinCount.fontSize = HUDSettings.fontSize
        cauldron.flameblinCount.fontColor = HUDSettings.fontColor
        cauldron.rockCount.fontName = HUDSettings.font
        cauldron.rockCount.fontSize = HUDSettings.fontSize
        cauldron.rockCount.fontColor = HUDSettings.fontColor
        cauldron.gumblingCount.fontName = HUDSettings.font
        cauldron.gumblingCount.fontSize = HUDSettings.fontSize
        cauldron.gumblingCount.fontColor = HUDSettings.fontColor
        
        cauldron.currentGoblinsNumberLabel.text = String(cauldron.currentGoblinsNumber) + "/" + String(cauldron.maxGoblinNumber)
        
    }
    
    func addSheet(sheet: Sheet, position: CGPoint) {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            HUDSettings.sheetSize = CGSize(width: UIScreen.main.bounds.width/2.9, height: UIScreen.main.bounds.height/1.1)
            HUDSettings.fontSize = 15
            HUDSettings.statsFontSize = 8
            break
        case .pad:
            HUDSettings.sheetSize = CGSize(width: UIScreen.main.bounds.width/2.6, height: UIScreen.main.bounds.height/1.5)
            HUDSettings.fontSize = 28
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
        sheet.descLabel.fontName = HUDSettings.font
        
        sheet.healthLabel.fontName = HUDSettings.font
        sheet.attackLabel.fontName = HUDSettings.font
        sheet.fearLabel.fontName = HUDSettings.font
        sheet.ageLabel.fontName = HUDSettings.font
        sheet.witLabel.fontName = HUDSettings.font
        sheet.frenzyLabel.fontName = HUDSettings.font

        
        sheet.nameLabel.fontSize = HUDSettings.fontSize
        sheet.descLabel.fontSize = HUDSettings.fontSize
        
        sheet.healthLabel.fontSize = HUDSettings.statsFontSize
        sheet.attackLabel.fontSize = HUDSettings.statsFontSize
        sheet.fearLabel.fontSize = HUDSettings.statsFontSize
        sheet.ageLabel.fontSize = HUDSettings.statsFontSize
        sheet.witLabel.fontSize = HUDSettings.statsFontSize
        sheet.frenzyLabel.fontSize = HUDSettings.statsFontSize
        
        sheet.nameLabel.fontColor = HUDSettings.fontColor
        sheet.descLabel.fontColor = HUDSettings.fontColor
        sheet.healthLabel.fontColor = HUDSettings.fontColor
        sheet.attackLabel.fontColor = HUDSettings.fontColor
        sheet.fearLabel.fontColor = HUDSettings.fontColor
        sheet.ageLabel.fontColor = HUDSettings.fontColor
        sheet.witLabel.fontColor = HUDSettings.fontColor
        sheet.frenzyLabel.fontColor = HUDSettings.fontColor
        
        sheet.typeLabel.size = CGSize(width: sheet.size.width/4, height: sheet.size.width/7)
        
        sheet.nameLabel.position = CGPoint(x: sheet.frame.maxX * -0.08,
                                           y: sheet.frame.maxY * 0.55)
        sheet.typeLabel.position = CGPoint(x: sheet.frame.maxX * -0.233,
                                           y: sheet.frame.maxY * 0.42)
        sheet.descLabel.position = CGPoint(x: 0,
                                           y: sheet.frame.minY * 0.08)
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
        
    }
    
    func addEvilGauge(evilGauge: EvilGauge, position: CGPoint) {
        evilGauge.zPosition = 80
        evilGauge.position = position
        addChild(evilGauge)
        
        evilGauge.gaugeBorder.position = CGPoint(x: 0, y: evilGauge.frame.midY*1.5)
        evilGauge.gaugeFill.position = CGPoint(x: 0, y: evilGauge.frame.midY*1.5)
        
        evilGauge.physicsBody = nil
        evilGauge.physicsBody?.isDynamic = false
        evilGauge.physicsBody?.categoryBitMask = Collision.Masks.map.bitmask
        
    }
    
    func addScrollableMenu(scrollableMenu: ScrollableMenu, position: CGPoint) {
        scrollableMenu.alpha = 0.0
        scrollableMenu.zPosition = 100
        addChild(scrollableMenu)
        scrollableMenu.position = position
        
        scrollableMenu.nameLabel.position = CGPoint(x: 0,
                                           y: scrollableMenu.frame.maxY * 0.75)
        scrollableMenu.descLabel.position = CGPoint(x: 0,
                                                    y: scrollableMenu.frame.maxY * 0.55)
        
        scrollableMenu.nameLabel.fontName = HUDSettings.font
        scrollableMenu.descLabel.fontName = HUDSettings.font

        scrollableMenu.nameLabel.fontSize = HUDSettings.fontSize
        scrollableMenu.descLabel.fontSize = HUDSettings.fontSize
        
//        scrollableMenu.nameLabel.fontColor = HUDSettings.fontColor
        scrollableMenu.nameLabel.fontColor = .white
        scrollableMenu.descLabel.fontColor = HUDSettings.fontColor
        
        scrollableMenu.nameLabel.verticalAlignmentMode = .center
        scrollableMenu.descLabel.verticalAlignmentMode = .top
        scrollableMenu.descLabel.preferredMaxLayoutWidth = scrollableMenu.frame.width - scrollableMenu.frame.width/6
        scrollableMenu.descLabel.numberOfLines = Int(scrollableMenu.descLabel.frame.width / scrollableMenu.frame.width)
        
    }
    
    func addPauseScreen(pauseScreen: PauseScreen, position: CGPoint) {
        pauseScreen.alpha = 0.0
        
        pauseScreen.zPosition = 300
        addChild(pauseScreen)
        pauseScreen.position = position
        
        pauseScreen.pauseSign.zPosition = 5
        pauseScreen.pauseSign.position = CGPoint.zero
        
        pauseScreen.pauseMessage.size = CGSize(width: pauseScreen.pauseSign.size.width/2, height: pauseScreen.pauseSign.size.width/10)
        pauseScreen.pauseMessage.position = CGPoint(x: 0, y: pauseScreen.pauseSign.size.height/5.2)
        pauseScreen.pauseMessage.zPosition = 5
        
        pauseScreen.continueMessage.size = CGSize(width: pauseScreen.pauseSign.size.width/5, height: pauseScreen.pauseSign.size.width/10)
        pauseScreen.continueMessage.position = CGPoint(x: 0, y: pauseScreen.pauseSign.size.height/10)
        pauseScreen.continueMessage.zPosition = 5

        pauseScreen.exitMessage.size = CGSize(width: pauseScreen.pauseSign.size.width/5, height: pauseScreen.pauseSign.size.width/10)
        pauseScreen.exitMessage.position = CGPoint(x: pauseScreen.pauseSign.size.width/4, y: pauseScreen.pauseSign.size.height/10)
        pauseScreen.exitMessage.zPosition = 5

        pauseScreen.restartMessage.size = CGSize(width: pauseScreen.pauseSign.size.width/5, height: pauseScreen.pauseSign.size.width/10)
        pauseScreen.restartMessage.position = CGPoint(x: -pauseScreen.pauseSign.size.width/4, y: pauseScreen.pauseSign.size.height/10)
        pauseScreen.restartMessage.zPosition = 5
        
        pauseScreen.continueButton.size = CGSize(width: pauseScreen.pauseSign.size.width/10, height: pauseScreen.pauseSign.size.width/10)
        pauseScreen.continueButton.zPosition = 5
        pauseScreen.continueButton.position = CGPoint(x: pauseScreen.continueMessage.position.x, y: -pauseScreen.pauseSign.size.height/5.2)
        
        pauseScreen.quitButton.size = CGSize(width: pauseScreen.pauseSign.size.width/10, height: pauseScreen.pauseSign.size.width/10)
        pauseScreen.quitButton.position = CGPoint(x: pauseScreen.exitMessage.position.x, y: -pauseScreen.pauseSign.size.height/5.2)
        pauseScreen.quitButton.zPosition = 10
    
        pauseScreen.restartButton.size = CGSize(width: pauseScreen.pauseSign.size.width/10, height: pauseScreen.pauseSign.size.width/10)
        pauseScreen.restartButton.position = CGPoint(x: pauseScreen.restartMessage.position.x, y: -pauseScreen.pauseSign.size.height/5.2)
        pauseScreen.restartButton.zPosition = 5
    }
    
    func addPauseButton(pauseButton: PauseButton, position: CGPoint){
        pauseButton.alpha = 1.0
        pauseButton.zPosition = 20
        pauseButton.position = position
        
        addChild(pauseButton)
    }

}
