//
//  TutorialSheet.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 07/06/22.
//

import Foundation
import SpriteKit

class TutorialSheet: SKSpriteNode, ObservableObject {
    static let shared: TutorialSheet = TutorialSheet()
    
    var isMenu: Bool = false
    var tutorialCounter: Int = 0
    let backButton: SKSpriteNode = SKSpriteNode(imageNamed: "left-arrow")
    let leftTutorial: SKSpriteNode = SKSpriteNode(imageNamed: "back-button")
    let rightTutorial: SKSpriteNode = SKSpriteNode(imageNamed: "next-button")
    let tutorialSign: SKSpriteNode = SKSpriteNode(imageNamed: "structure sheet wide")
    var tutorialName: SKLabelNode = SKLabelNode()
    var tutorialDesc: SKLabelNode = SKLabelNode()
    var screen: SKSpriteNode = SKSpriteNode(imageNamed: "goblinHead")
    let darkLordEye: SKSpriteNode = SKSpriteNode(imageNamed: "darkLordEye")
    
    init() {
        super.init(texture: SKTexture(imageNamed: "pause-overlay"), color: .clear, size: CGSize(width: UIScreen.main.bounds.width,
                                                            height: UIScreen.main.bounds.height))
        self.name = "tutorialSheet"
        self.alpha = 0.0
        
        self.addChild(backButton)
        self.backButton.name = "backButton"
        self.backButton.alpha = 0.0
        self.addChild(leftTutorial)
        self.leftTutorial.name = "leftTutorial"
        self.leftTutorial.alpha = 0.0
        self.addChild(rightTutorial)
        self.rightTutorial.name = "rightTutorial"
        self.rightTutorial.alpha = 0.0
        self.addChild(tutorialSign)
        self.tutorialSign.name = "tutorialSign"
        self.addChild(tutorialName)
        self.tutorialName.name = "tutorialName"
        self.addChild(tutorialDesc)
        self.tutorialDesc.name = "tutorialDesc"
        self.addChild(screen)
        self.screen.name = "screen"
//        self.addChild(darkLordEye)
        self.darkLordEye.name = "darkLordEye"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
