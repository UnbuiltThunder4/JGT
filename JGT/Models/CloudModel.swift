//
//  TutorialButton.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 07/06/22.
//

import Foundation
import SpriteKit

class Cloud: SKSpriteNode, Identifiable {
    
    var goblinCounter: SKLabelNode = SKLabelNode()
    var counter: Int = 0
    var structureName: String = ""
    
    init(structureName: String) {
        
        super.init(texture: SKTexture(imageNamed: "cloud_structure_full"), color: .clear, size: CGSize(width: UIScreen.main.bounds.width/17.0, height: UIScreen.main.bounds.width/17.0))
        self.structureName = structureName
        
        self.name = "goblinCloud"
        self.alpha = 0.0
        self.goblinCounter.name = "goblinCounter"
        self.goblinCounter.alpha = 0.0
        self.goblinCounter.zPosition = 20
        self.goblinCounter.fontName = HUDSettings.nameFont
        self.goblinCounter.fontSize = 50
        self.goblinCounter.fontColor = .red
        self.addChild(goblinCounter)
    }
    
    func updateCloud(value: Int) {
        self.goblinCounter.text = String(counter + value)
        if self.counter == 0 {
            self.alpha = 0.0
        } else {
            self.alpha = 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

