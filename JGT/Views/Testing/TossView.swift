//
//  TossView.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SwiftUI
import SpriteKit

struct TossView: View {
    
    @Binding var currentScene: SpriteKitContainer
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var body: some View {
        
        currentScene
            .ignoresSafeArea()
            .onChange(of: gameLogic.gameState) { newValue in
                if newValue != .playing {
                    currentScene = SpriteKitContainer(scene: TossScene())
                }
            }
    }
}
