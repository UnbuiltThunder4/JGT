//
//  TossView.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SwiftUI
import SpriteKit

struct TossView: View {
    
//    @State var container: SpriteKitContainer?
    var currentScene: SKScene?
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    init() {
        self.currentScene = TossScene()
        
    }
    
    var body: some View {
        
        SpriteKitContainer(scene: currentScene!)
            .ignoresSafeArea()
//            .onChange(of: gameLogic.gameState) { newValue in
//                if newValue != .playing {
//                    if let scene = self.currentScene as? SKScene {
//                        self.currentScene = nil
//                        scene.view?.presentScene(nil)
//                        self.currentScene = TossScene()
//                        self.container = SpriteKitContainer(skScene: $currentScene)
//                        self.currentScene!.view?.presentScene(self.currentScene)
//                    }
//                }
//            }
    }
}
