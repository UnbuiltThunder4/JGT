//
//  TossView.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SwiftUI
import SpriteKit

struct TossView: View {
    
    @Binding var currentGameState: GameState
    
    var body: some View {
        
        SpriteKitContainer(scene: TossScene(level: 0))
            .ignoresSafeArea()
    }
}

struct TossView_Previews: PreviewProvider {
    static var previews: some View {
        TossView(currentGameState: .constant(GameState.playing))
    }
}
