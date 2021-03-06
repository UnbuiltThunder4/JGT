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
    static var statsFont = "CrayonHandRegular2016Demo"
    static var nameFontSize: CGFloat = 40
    static var descFontSize: CGFloat = 25
    static var statsFontSize: CGFloat = 15
    static var nameFontColor: UIColor = .orange
    static var descFontColor: UIColor = .brown
    static var tutorialNameFontSize: CGFloat = 55
    static var tutorialCounterFontSize: CGFloat = ((UIDevice.current.userInterfaceIdiom == .pad) ? 50 : 25)
    static var tutorialDescFontSize: CGFloat = 40
}

class HUD: SKNode, ObservableObject {
    var counter: Int = 0
    var tutorialCounter: SKLabelNode = SKLabelNode()
    var livesCounter: SKLabelNode = SKLabelNode()
    
    override init() {
        super.init()
        self.tutorialCounter.zPosition = 50
        self.addChild(tutorialCounter)
        self.tutorialCounter.name = "tutorialHUDcounter"
        self.tutorialCounter.alpha = 0.0
        self.tutorialCounter.text = String(self.counter)
        self.livesCounter.name = "livesCounter"
        self.livesCounter.text = "X 10"
        self.addChild(livesCounter)
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
            HUDSettings.sheetSize = CGSize(width: UIScreen.main.bounds.width/2.9, height: UIScreen.main.bounds.height/1.3)
            HUDSettings.nameFontSize = 25
            HUDSettings.descFontSize = 15
            HUDSettings.statsFontSize = 8
            break
        case .pad:
            HUDSettings.sheetSize = CGSize(width: UIScreen.main.bounds.width/2.7, height: UIScreen.main.bounds.height/1.6)
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
        
        sheet.healthLabel.fontName = HUDSettings.statsFont
        sheet.attackLabel.fontName = HUDSettings.statsFont
        sheet.fearLabel.fontName = HUDSettings.statsFont
        sheet.ageLabel.fontName = HUDSettings.statsFont
        sheet.witLabel.fontName = HUDSettings.statsFont
        sheet.frenzyLabel.fontName = HUDSettings.statsFont
        
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
        sheet.typeLabel.position = CGPoint(x: ((UIDevice.current.userInterfaceIdiom == .pad) ? sheet.frame.maxX * -0.233 : sheet.frame.maxX * -0.22),
                                           y: sheet.frame.maxY * 0.40)
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
        
        scrollableMenu.nameLabel.fontColor = .black
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
        
        pauseScreen.pauseSign.size = CGSize(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.height/1.2)
        
        pauseScreen.continueMessage.fontSize = UIDevice.current.userInterfaceIdiom == .pad ?
        HUDSettings.tutorialNameFontSize : 35
        pauseScreen.continueMessage.fontName = HUDSettings.nameFont
        pauseScreen.continueMessage.fontColor = .brown
        pauseScreen.continueMessage.text = "Continue"
        pauseScreen.continueMessage.position = CGPoint(x:-pauseScreen.pauseSign.size.width/3.3, y: pauseScreen.pauseSign.size.height/5.5)
        pauseScreen.continueMessage.zPosition = 5
        
        pauseScreen.exitMessage.fontSize = UIDevice.current.userInterfaceIdiom == .pad ?
        HUDSettings.tutorialNameFontSize : 35
        pauseScreen.exitMessage.fontName = HUDSettings.nameFont
        pauseScreen.exitMessage.fontColor = .brown
        pauseScreen.exitMessage.text = "Levels"
        pauseScreen.exitMessage.position = CGPoint(x: pauseScreen.pauseSign.size.width/3.3, y: pauseScreen.pauseSign.size.height/5.5)
        pauseScreen.exitMessage.zPosition = 5

        pauseScreen.restartMessage.fontSize = UIDevice.current.userInterfaceIdiom == .pad ?
        HUDSettings.tutorialNameFontSize : 35
        pauseScreen.restartMessage.fontName = HUDSettings.nameFont
        pauseScreen.restartMessage.fontColor = .brown
        pauseScreen.restartMessage.text = "Restart"
        pauseScreen.restartMessage.position = CGPoint(x: pauseScreen.pauseSign.size.width/10, y: pauseScreen.pauseSign.size.height/5.5)
        pauseScreen.restartMessage.zPosition = 5
        
        pauseScreen.tutorialMessage.fontSize = UIDevice.current.userInterfaceIdiom == .pad ?
        HUDSettings.tutorialNameFontSize : 35
        pauseScreen.tutorialMessage.fontName = HUDSettings.nameFont
        pauseScreen.tutorialMessage.fontColor = .brown
        pauseScreen.tutorialMessage.text = "Tutorial"
        pauseScreen.tutorialMessage.position = CGPoint(x: -pauseScreen.pauseSign.size.width/10, y: pauseScreen.pauseSign.size.height/5.5)
        pauseScreen.tutorialMessage.zPosition = 5
        
        pauseScreen.continueButton.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: pauseScreen.pauseSign.size.width/5.5, height: pauseScreen.pauseSign.size.width/5.5) : CGSize(width: pauseScreen.pauseSign.size.width/6.5, height: pauseScreen.pauseSign.size.width/6.5)
        pauseScreen.continueButton.zPosition = 5
        pauseScreen.continueButton.position = CGPoint(x: pauseScreen.continueMessage.position.x, y: pauseScreen.pauseSign.frame.midY*2)
        
        pauseScreen.quitButton.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: pauseScreen.pauseSign.size.width/5.5, height: pauseScreen.pauseSign.size.width/5.5) : CGSize(width: pauseScreen.pauseSign.size.width/6.5, height: pauseScreen.pauseSign.size.width/6.5)
        pauseScreen.quitButton.position = CGPoint(x: pauseScreen.exitMessage.position.x, y: pauseScreen.pauseSign.frame.midY*2)
        pauseScreen.quitButton.zPosition = 10
        
        pauseScreen.tutorialButton.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: pauseScreen.pauseSign.size.width/5.5, height: pauseScreen.pauseSign.size.width/5.5) : CGSize(width: pauseScreen.pauseSign.size.width/6.5, height: pauseScreen.pauseSign.size.width/6.5)
        pauseScreen.tutorialButton.position = CGPoint(x: pauseScreen.tutorialMessage.position.x, y: pauseScreen.pauseSign.frame.midY*2)
        pauseScreen.tutorialButton.zPosition = 10
    
        pauseScreen.restartButton.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: pauseScreen.pauseSign.size.width/5.5, height: pauseScreen.pauseSign.size.width/5.5) : CGSize(width: pauseScreen.pauseSign.size.width/6.5, height: pauseScreen.pauseSign.size.width/6.5)
        pauseScreen.restartButton.position = CGPoint(x: pauseScreen.restartMessage.position.x, y: pauseScreen.pauseSign.frame.midY*2)
        pauseScreen.restartButton.zPosition = 5
        
        pauseScreen.musicButton.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: pauseScreen.pauseSign.size.width/10, height: pauseScreen.pauseSign.size.width/10) : CGSize(width: pauseScreen.pauseSign.size.width/10.5, height: pauseScreen.pauseSign.size.width/10.5)
        pauseScreen.musicButton.position = CGPoint(x: pauseScreen.pauseSign.frame.maxX/2.2, y: pauseScreen.pauseSign.frame.minY/1.5)
        pauseScreen.musicButton.zPosition = 5
        
        pauseScreen.effectButton.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: pauseScreen.pauseSign.size.width/10, height: pauseScreen.pauseSign.size.width/10) : CGSize(width: pauseScreen.pauseSign.size.width/10.5, height: pauseScreen.pauseSign.size.width/10.5)
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
        self.tutorialCounter.fontSize = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 40
        self.tutorialCounter.fontName = HUDSettings.nameFont
        self.tutorialCounter.position = UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: UIScreen.main.bounds.width/2.5, y: -UIScreen.main.bounds.height/2.8) : CGPoint(x: UIScreen.main.bounds.width/2.5, y: -UIScreen.main.bounds.height/3)
        self.tutorialCounter.alpha = 1.0
        
        addChild(tutorialButton)
    }
    
    func addTutorialSheet(tutorialSheet: TutorialSheet, position: CGPoint) {
    
        tutorialSheet.zPosition = 300
        tutorialSheet.position = position
        
        tutorialSheet.tutorialSign.size = CGSize(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.height/1.2)
        
        tutorialSheet.backButton.zPosition = 20
        tutorialSheet.backButton.position = CGPoint(x: tutorialSheet.tutorialSign.frame.minX/1.3,
                                                    y: tutorialSheet.tutorialSign.frame.maxY/1.3)
        tutorialSheet.backButton.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: tutorialSheet.tutorialSign.frame.width/10, height: tutorialSheet.tutorialSign.frame.width/10) :
        CGSize(width: tutorialSheet.tutorialSign.frame.width/17, height: tutorialSheet.tutorialSign.frame.width/17)
        
        tutorialSheet.rightTutorial.zPosition = 20
        tutorialSheet.rightTutorial.position = CGPoint(x: tutorialSheet.tutorialSign.frame.maxX/1.5,
                                                       y: tutorialSheet.tutorialSign.frame.minY/1.4)
        tutorialSheet.rightTutorial.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: tutorialSheet.tutorialSign.frame.width/10, height: tutorialSheet.tutorialSign.frame.width/10) :
        CGSize(width: tutorialSheet.tutorialSign.frame.width/17, height: tutorialSheet.tutorialSign.frame.width/17)
        
        tutorialSheet.leftTutorial.zPosition = 20
        tutorialSheet.leftTutorial.position = CGPoint(x: -tutorialSheet.tutorialSign.frame.maxX/1.5,
                                                       y: tutorialSheet.tutorialSign.frame.minY/1.4)
        tutorialSheet.leftTutorial.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: tutorialSheet.tutorialSign.frame.width/10, height: tutorialSheet.tutorialSign.frame.width/10) :
        CGSize(width: tutorialSheet.tutorialSign.frame.width/17, height: tutorialSheet.tutorialSign.frame.width/17)
        
        tutorialSheet.tutorialName.position = CGPoint(x: 0,
                                                      y: tutorialSheet.tutorialSign.frame.maxY * 0.75)
        
        tutorialSheet.tutorialCounterLabel.zPosition = 20
        
        tutorialSheet.tutorialCounterLabel.fontColor = .black
        tutorialSheet.tutorialCounterLabel.fontSize = HUDSettings.tutorialCounterFontSize
        tutorialSheet.tutorialCounterLabel.fontName = HUDSettings.nameFont
        
        tutorialSheet.tutorialName.verticalAlignmentMode = .center
        tutorialSheet.tutorialName.fontColor = .black
        tutorialSheet.tutorialName.fontSize = UIDevice.current.userInterfaceIdiom == .pad ? HUDSettings.tutorialNameFontSize :
        HUDSettings.tutorialNameFontSize - 20
        tutorialSheet.tutorialName.fontName = HUDSettings.nameFont
        tutorialSheet.tutorialDesc.fontColor = HUDSettings.descFontColor
        tutorialSheet.tutorialDesc.fontSize = UIDevice.current.userInterfaceIdiom == .pad ? HUDSettings.tutorialDescFontSize - 2 :
        HUDSettings.tutorialDescFontSize - 21
        tutorialSheet.tutorialDesc.fontName = HUDSettings.descFont
        tutorialSheet.tutorialDesc.verticalAlignmentMode = .top
        tutorialSheet.tutorialDesc.preferredMaxLayoutWidth = tutorialSheet.tutorialSign.frame.width - tutorialSheet.tutorialSign.frame.width/2
        tutorialSheet.tutorialDesc.numberOfLines = Int(tutorialSheet.tutorialDesc.frame.width / tutorialSheet.tutorialSign.frame.width)
        tutorialSheet.tutorialDesc.position = CGPoint(x: -tutorialSheet.frame.width/7.5,
                                                      y: tutorialSheet.frame.height/4.5)
        
        tutorialSheet.darkLordEye.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: tutorialSheet.tutorialSign.frame.width/6.5,
                                                                                              height: tutorialSheet.tutorialSign.frame.width/6.5) : CGSize(width: tutorialSheet.tutorialSign.frame.width/10.5,
                                                                                                                                                           height: tutorialSheet.tutorialSign.frame.width/10.5)
        
        tutorialSheet.darkLordEye.position = CGPoint(x: 0,
                                                       y: tutorialSheet.tutorialSign.frame.minY/1.4)
        tutorialSheet.tutorialCounterLabel.position.x = tutorialSheet.darkLordEye.position.x
        tutorialSheet.tutorialCounterLabel.position.y = tutorialSheet.darkLordEye.position.y - (tutorialSheet.darkLordEye.frame.height * 0.1)
        tutorialSheet.screen.size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: tutorialSheet.tutorialSign.frame.width/3.7,
                                                                                         height: tutorialSheet.tutorialSign.frame.height/3.2) : CGSize(width: tutorialSheet.tutorialSign.frame.width/4.7,                  height: tutorialSheet.tutorialSign.frame.height/2.3)
        tutorialSheet.screen.position.x = tutorialSheet.tutorialSign.frame.maxX/2.0
        addChild(tutorialSheet)
    }
    
    func addDarkSonLives(position: CGPoint) {
        let dsFace: SKSpriteNode = SKSpriteNode(imageNamed: "dark-son-lives")
        dsFace.name = "dark-son-lives"
        dsFace.size = ((UIDevice.current.userInterfaceIdiom == .pad) ? CGSize(width: (dsFace.texture?.size().width)!, height: (dsFace.texture?.size().height)!) : CGSize(width: UIScreen.main.bounds.width/10.5, height: UIScreen.main.bounds.height/5.5))
        dsFace.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        dsFace.position = position
        dsFace.zPosition = 5
        addChild(dsFace)
        self.livesCounter.position.x = position.x + dsFace.frame.width/2
        self.livesCounter.position.y = position.y - dsFace.frame.height/4
        self.livesCounter.zPosition = 5
        self.livesCounter.fontName = HUDSettings.nameFont
        self.livesCounter.fontSize = HUDSettings.tutorialCounterFontSize
        self.livesCounter.fontColor = .white
    }

}
