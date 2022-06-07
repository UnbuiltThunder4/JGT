//
//  TutorialButton.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 07/06/22.
//

import Foundation
import SpriteKit

class TutorialButton: SKSpriteNode, Identifiable {
    
    var tutorialName: String = ""
    var tutorialDesc: String = ""
    var screen: SKTexture = SKTexture(imageNamed: "goblinHead")
    
    init(tutorialName: String, tutorialDesc: String, screen: SKTexture) {
        self.tutorialName = tutorialName
        self.tutorialDesc = tutorialDesc
        self.screen = screen
        
        super.init(texture: SKTexture(imageNamed: "info-button"), color: .clear, size: CGSize(width: UIScreen.main.bounds.width/17.0, height: UIScreen.main.bounds.width/17.0))
        self.name = "tutorialButton"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

