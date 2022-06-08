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
    static var descFont = "Chalk-Regular"
    static var nameFont = "Nightmare"
    static var nameFontSize: CGFloat = 40
    static var descFontSize: CGFloat = 25
    static var statsFontSize: CGFloat = 15
    static var nameFontColor: UIColor = .orange
    static var descFontColor: UIColor = .brown
}

class HUD: SKNode, ObservableObject {
    
    static let shared: HUD = HUD()
    var counter: Int = 0
    var tutorialCounter: SKLabelNode = SKLabelNode()
    
    override init() {
        super.init()
        self.tutorialCounter.zPosition = 50
        self.addChild(tutorialCounter)
        self.tutorialCounter.name = "tutorialHUDcounter"
        self.tutorialCounter.alpha = 0.0
        self.tutorialCounter.text = String(self.counter)
        self.name = "HUD"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCauldron(cauldron: Cauldron, position: CGPoint) {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            HUDSettings.cauldronSize = CGSize(width: UIScreen.main.bounds.height/5.4, height: UIScreen.main.bounds.height/5.4)
            HUDSettings.nameFontSize = 25
            HUDSettings.descFontSize = 15
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
        
        cauldron.currentGoblinsNumberLabel.fontName = HUDSettings.nameFont
        cauldron.currentGoblinsNumberLabel.fontSize = HUDSettings.nameFontSize
        cauldron.currentGoblinsNumberLabel.fontColor = HUDSettings.nameFontColor
        
        cauldron.goblinCount.fontName = HUDSettings.nameFont
        cauldron.goblinCount.fontSize = HUDSettings.nameFontSize
        cauldron.goblinCount.fontColor = HUDSettings.descFontColor
        cauldron.flameblinCount.fontName = HUDSettings.nameFont
        cauldron.flameblinCount.fontSize = HUDSettings.nameFontSize
        cauldron.flameblinCount.fontColor = HUDSettings.descFontColor
        cauldron.rockCount.fontName = HUDSettings.nameFont
        cauldron.rockCount.fontSize = HUDSettings.nameFontSize
        cauldron.rockCount.fontColor = HUDSettings.descFontColor
        cauldron.gumblingCount.fontName = HUDSettings.nameFont
        cauldron.gumblingCount.fontSize = HUDSettings.nameFontSize
        cauldron.gumblingCount.fontColor = HUDSettings.descFontColor
        
        cauldron.currentGoblinsNumberLabel.text = String(cauldron.currentGoblinsNumber) + "/" + String(cauldron.maxGoblinNumber)
        
    }
    
    func addSheet(sheet: Sheet, position: CGPoint) {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            HUDSettings.sheetSize = CGSize(width: UIScreen.main.bounds.width/2.9, height: UIScreen.main.bounds.height/1.1)
            HUDSettings.nameFontSize = 25
            HUDSettings.descFontSize = 15
            HUDSettings.statsFontSize = 8
            break
        case .pad:
            HUDSettings.sheetSize = CGSize(width: UIScreen.main.bounds.width/2.6, height: UIScreen.main.bounds.height/1.5)
            HUDSettings.nameFontSize = 35
            HUDSettings.descFontSize = 25
            HUDSettings.statsFontSize = 15
            break
        @unknown default:
            break
        }
        sheet.alpha = 0.0
        sheet.zPosition = 100
        addChild(sheet)
        sheet.position = position
        
        sheet.size = HUDSettings.sheetSize
        
        sheet.nameLabel.fontName = HUDSettings.nameFont
        sheet.descLabel.fontName = HUDSettings.descFont
        
        sheet.healthLabel.fontName = HUDSettings.descFont
        sheet.attackLabel.fontName = HUDSettings.descFont
        sheet.fearLabel.fontName = HUDSettings.descFont
        sheet.ageLabel.fontName = HUDSettings.descFont
        sheet.witLabel.fontName = HUDSettings.descFont
        sheet.frenzyLabel.fontName = HUDSettings.descFont

        
        sheet.nameLabel.fontSize = HUDSettings.nameFontSize
        sheet.descLabel.fontSize = HUDSettings.descFontSize
        
        sheet.healthLabel.fontSize = HUDSettings.statsFontSize
        sheet.attackLabel.fontSize = HUDSettings.statsFontSize
        sheet.fearLabel.fontSize = HUDSettings.statsFontSize
        sheet.ageLabel.fontSize = HUDSettings.statsFontSize
        sheet.witLabel.fontSize = HUDSettings.statsFontSize
        sheet.frenzyLabel.fontSize = HUDSettings.statsFontSize
        
        sheet.nameLabel.fontColor = HUDSettings.nameFontColor
        sheet.descLabel.fontColor = HUDSettings.descFontColor
        sheet.healthLabel.fontColor = HUDSettings.nameFontColor
        sheet.attackLabel.fontColor = HUDSettings.nameFontColor
        sheet.fearLabel.fontColor = HUDSettings.nameFontColor
        sheet.ageLabel.fontColor = HUDSettings.nameFontColor
        sheet.witLabel.fontColor = HUDSettings.nameFontColor
        sheet.frenzyLabel.fontColor = HUDSettings.nameFontColor
        
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
        
        scrollableMenu.nameLabel.fontName = HUDSettings.nameFont
        scrollableMenu.descLabel.fontName = HUDSettings.descFont

        scrollableMenu.nameLabel.fontSize = HUDSettings.nameFontSize
        scrollableMenu.descLabel.fontSize = HUDSettings.descFontSize
        
        scrollableMenu.nameLabel.fontColor = .white
        scrollableMenu.descLabel.fontColor = HUDSettings.descFontColor
        
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
        
        pauseScreen.continueMessage.fontSize = HUDSettings.nameFontSize
        pauseScreen.continueMessage.fontName = HUDSettings.nameFont
        pauseScreen.continueMessage.fontColor = HUDSettings.nameFontColor
        pauseScreen.continueMessage.text = "Continue"
        pauseScreen.continueMessage.position = CGPoint(x:-pauseScreen.pauseSign.size.width/4, y: pauseScreen.pauseSign.size.height/5)
        pauseScreen.continueMessage.zPosition = 5
        
        pauseScreen.exitMessage.fontSize = HUDSettings.nameFontSize
        pauseScreen.exitMessage.fontName = HUDSettings.nameFont
        pauseScreen.exitMessage.fontColor = HUDSettings.nameFontColor
        pauseScreen.exitMessage.text = "Level Selection"
        pauseScreen.exitMessage.position = CGPoint(x: pauseScreen.pauseSign.size.width/4, y: pauseScreen.pauseSign.size.height/5)
        pauseScreen.exitMessage.zPosition = 5

        pauseScreen.restartMessage.fontSize = HUDSettings.nameFontSize
        pauseScreen.restartMessage.fontName = HUDSettings.nameFont
        pauseScreen.restartMessage.fontColor = HUDSettings.nameFontColor
        pauseScreen.restartMessage.text = "Restart"
        pauseScreen.restartMessage.position = CGPoint(x: pauseScreen.pauseSign.size.width/8, y: pauseScreen.pauseSign.size.height/5)
        pauseScreen.restartMessage.zPosition = 5
        
        pauseScreen.tutorialMessage.fontSize = HUDSettings.nameFontSize
        pauseScreen.tutorialMessage.fontName = HUDSettings.nameFont
        pauseScreen.tutorialMessage.fontColor = HUDSettings.nameFontColor
        pauseScreen.tutorialMessage.text = "Tutorial"
        pauseScreen.tutorialMessage.position = CGPoint(x: -pauseScreen.pauseSign.size.width/8, y: pauseScreen.pauseSign.size.height/5)
        pauseScreen.tutorialMessage.zPosition = 5
        
        pauseScreen.continueButton.size = CGSize(width: pauseScreen.pauseSign.size.width/5, height: pauseScreen.pauseSign.size.width/5)
        pauseScreen.continueButton.zPosition = 5
        pauseScreen.continueButton.position = CGPoint(x: pauseScreen.continueMessage.position.x, y: pauseScreen.pauseSign.frame.midY*2)
        
        pauseScreen.quitButton.size = CGSize(width: pauseScreen.pauseSign.size.width/5, height: pauseScreen.pauseSign.size.width/5)
        pauseScreen.quitButton.position = CGPoint(x: pauseScreen.exitMessage.position.x, y: pauseScreen.pauseSign.frame.midY*2)
        pauseScreen.quitButton.zPosition = 10
        
        pauseScreen.tutorialButton.size = CGSize(width: pauseScreen.pauseSign.size.width/5, height: pauseScreen.pauseSign.size.width/5)
        pauseScreen.tutorialButton.position = CGPoint(x: pauseScreen.tutorialMessage.position.x, y: pauseScreen.pauseSign.frame.midY*2)
        pauseScreen.tutorialButton.zPosition = 10
    
        pauseScreen.restartButton.size = CGSize(width: pauseScreen.pauseSign.size.width/5, height: pauseScreen.pauseSign.size.width/5)
        pauseScreen.restartButton.position = CGPoint(x: pauseScreen.restartMessage.position.x, y: pauseScreen.pauseSign.frame.midY*2)
        pauseScreen.restartButton.zPosition = 5
        
        pauseScreen.musicButton.size = CGSize(width: pauseScreen.pauseSign.size.width/10, height: pauseScreen.pauseSign.size.width/10)
        pauseScreen.musicButton.position = CGPoint(x: pauseScreen.pauseSign.frame.maxX/2.2, y: pauseScreen.pauseSign.frame.minY/1.5)
        pauseScreen.musicButton.zPosition = 5
        
        pauseScreen.effectButton.size = CGSize(width: pauseScreen.pauseSign.size.width/10, height: pauseScreen.pauseSign.size.width/10)
        pauseScreen.effectButton.position = CGPoint(x: pauseScreen.pauseSign.frame.maxX/1.5, y: pauseScreen.pauseSign.frame.minY/1.5)
        pauseScreen.effectButton.zPosition = 5
    }
    
    func addPauseButton(pauseButton: PauseButton, position: CGPoint){
        pauseButton.alpha = 1.0
        pauseButton.zPosition = 20
        pauseButton.position = position
        
        addChild(pauseButton)
    }
    
    func addTutorialButton(tutorialButton: TutorialButton, position: CGPoint) {
        tutorialButton.alpha = 1.0
        tutorialButton.zPosition = 20
        tutorialButton.position = position
        self.tutorialCounter.fontColor = .red
        self.tutorialCounter.fontSize = 50
        self.tutorialCounter.fontName = HUDSettings.nameFont
//        self.tutorialCounter.position.y = tutorialButton.position.y - self.tutorialCounter.frame.height/2
        self.tutorialCounter.position.x = position.x
        self.tutorialCounter.position.y = tutorialCounter.frame.minY
        self.tutorialCounter.alpha = 1.0
        
        addChild(tutorialButton)
    }
    
    func addTutorialSheet(tutorialSheet: TutorialSheet, position: CGPoint) {
    
        tutorialSheet.zPosition = 300
        tutorialSheet.position = position
        
        tutorialSheet.backButton.zPosition = 20
        tutorialSheet.backButton.position = CGPoint(x: -tutorialSheet.tutorialSign.frame.maxX/1.5,
                                                       y: -tutorialSheet.tutorialSign.frame.minY/1.5)
        tutorialSheet.rightTutorial.zPosition = 20
        tutorialSheet.rightTutorial.position = CGPoint(x: tutorialSheet.tutorialSign.frame.maxX/1.5,
                                                       y: tutorialSheet.tutorialSign.frame.minY/1.5)
        tutorialSheet.leftTutorial.zPosition = 20
        tutorialSheet.leftTutorial.position = CGPoint(x: -tutorialSheet.tutorialSign.frame.maxX/1.5,
                                                       y: tutorialSheet.tutorialSign.frame.minY/1.5)
        tutorialSheet.tutorialName.position = CGPoint(x: 0,
                                                      y: tutorialSheet.tutorialSign.frame.maxY * 0.75)
        
        tutorialSheet.tutorialCounterLabel.zPosition = 20
        tutorialSheet.tutorialCounterLabel.position = CGPoint(x: 0,
                                                              y: tutorialSheet.tutorialSign.frame.minY/1.5)
        
        tutorialSheet.tutorialCounterLabel.fontColor = HUDSettings.descFontColor
        tutorialSheet.tutorialCounterLabel.fontSize = HUDSettings.descFontSize
        tutorialSheet.tutorialCounterLabel.fontName = HUDSettings.nameFont
        tutorialSheet.tutorialName.fontColor = HUDSettings.nameFontColor
        tutorialSheet.tutorialName.fontSize = HUDSettings.nameFontSize
        tutorialSheet.tutorialName.fontName = HUDSettings.nameFont
        tutorialSheet.tutorialDesc.fontColor = HUDSettings.descFontColor
        tutorialSheet.tutorialDesc.fontSize = HUDSettings.descFontSize
        tutorialSheet.tutorialDesc.fontName = HUDSettings.descFont
        tutorialSheet.tutorialDesc.verticalAlignmentMode = .top
        tutorialSheet.tutorialDesc.preferredMaxLayoutWidth = tutorialSheet.tutorialSign.frame.width - tutorialSheet.tutorialSign.frame.width/6
        tutorialSheet.tutorialDesc.numberOfLines = Int(tutorialSheet.tutorialDesc.frame.width / tutorialSheet.tutorialSign.frame.width)
        
        addChild(tutorialSheet)
    }

}
