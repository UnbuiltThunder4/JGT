//
//  PauseScreen.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 03/06/22.
//

import Foundation
import SpriteKit

class PauseScreen: SKSpriteNode {
    let pauseSign = SKSpriteNode(imageNamed: "structure sheet wide")
    let continueButton = SKSpriteNode(imageNamed: "continueButton")
    let quitButton = SKSpriteNode(imageNamed: "quitButton")
    let restartButton = SKSpriteNode(imageNamed: "restartButton")
    let pauseMessage = SKSpriteNode(imageNamed: "pauseTitle")
    let continueMessage = SKSpriteNode(imageNamed: "continueMessage")
    let exitMessage = SKSpriteNode(imageNamed: "exitTitle")
    let restartMessage = SKSpriteNode(imageNamed: "restartMessage")
    let littleButtonsSize = CGSize(width: UIScreen.main.bounds.width/17.0, height: UIScreen.main.bounds.width/17.0)
    
    init() {
        
    super.init(texture: SKTexture(imageNamed: "pause-overlay"), color: .clear, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        
        self.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        self.name = "pauseScreen"
        self.alpha = 0.2
        
        self.addChild(pauseSign)
        self.addChild(continueButton)
        self.addChild(quitButton)
        self.addChild(restartButton)
        self.addChild(pauseMessage)
        self.addChild(continueMessage)
        self.addChild(exitMessage)
        self.addChild(restartMessage)
        
        pauseSign.name = "pauseSign"
        continueButton.name = "ContinueBtn"
        quitButton.name = "QuitBtn"
        restartButton.name = "RestartBtn"
        pauseMessage.name = "pauseMessage"
        continueMessage.name = "continueMessage"
        exitMessage.name = "exitMessage"
        restartMessage.name = "restartMessage"
    
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
