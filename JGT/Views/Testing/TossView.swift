//
//  TossView.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 11/05/22.
//

import SwiftUI
import SpriteKit

struct TossView: View {
    
    var gameScene = TossScene()
    
    var body: some View {
        SpriteView(scene: gameScene)
            .ignoresSafeArea()
    }
}

struct TossView_Previews: PreviewProvider {
    static var previews: some View {
        TossView()
    }
}
