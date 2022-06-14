//
//  TossView.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SwiftUI
import SpriteKit

struct TossView: View {
    
    @Binding var container: SpriteKitContainer?
    @Binding var currentScene: SKScene?
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var body: some View {
        
        container
            .ignoresSafeArea()
            .onChange(of: gameLogic.gameState) { newValue in
                if newValue != .playing {
                    currentScene = TossScene()
                }
            }
    }
}
