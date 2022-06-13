//
//  TossView.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SwiftUI
import SpriteKit

struct TossView: View {
    
//    @Binding var currentGameState: GameState
    @State var scene = SpriteKitContainer(scene: TossScene())
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var body: some View {
        
        scene
            .ignoresSafeArea()
            .onChange(of: gameLogic.gameState) { newValue in
                if newValue == .selection {
                    scene = SpriteKitContainer(scene: TossScene())
                }
            }
    }
}
