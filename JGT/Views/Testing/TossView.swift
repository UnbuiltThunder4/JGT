//
//  TossView.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SwiftUI
import SpriteKit

struct TossView: View {
    var currentScene: SKScene?
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    init() {
        self.currentScene = TossScene()
    }
    
    var body: some View {
        SpriteKitContainer(scene: currentScene!)
            .ignoresSafeArea()
    }
}
