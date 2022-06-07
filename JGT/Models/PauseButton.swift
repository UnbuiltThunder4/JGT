//
//  PauseButton.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 03/06/22.
//

import Foundation
import SpriteKit

class PauseButton: SKSpriteNode {
    init() {
        super.init(texture: SKTexture(imageNamed: "pause-on"), color: .clear, size: CGSize(width: UIScreen.main.bounds.width/17.0, height: UIScreen.main.bounds.width/17.0))
        self.name = "PauseBtn"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
