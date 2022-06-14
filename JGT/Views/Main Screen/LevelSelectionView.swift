//
//  MainScreenView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import SwiftUI
import UIKit

/**
 * # MainScreenView
 *
 *   This view is responsible for presenting the game name, the game intructions and to start the game.
 *  - Customize it as much as you want.
 *  - Experiment with colors and effects on the interface
 *  - Adapt the "Insert a Coin Button" to the visual identity of your game
 **/

struct LevelSelectionView: View {
    
    // The game state is used to transition between the different states of the game
    @Binding var currentGameState: GameState
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    // Change it on the Constants.swift file
    var gameTitle: String = MainScreenProperties.gameTitle
    
    // Change it on the Constants.swift file
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    // Change it on the Constants.swift file
    let accentColor: Color = MainScreenProperties.accentColor
    
    @State var index: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                
                HStack {
                Button {
                    withAnimation {
                        gameLogic.level = 1
                        gameLogic.gameState = .playing
                        print(gameLogic.level)
                    }
                } label: {
                    Text("Play 1")
                        .font(.custom("Chalkduster", size: (UIDevice.current.userInterfaceIdiom == .pad ? 30 : 15)))

                }
                .frame(maxWidth: geometry.size.width * 0.1, maxHeight: geometry.size.height * 0.1)
                .padding(5)
                .foregroundColor(.white)
                .background(self.accentColor)
                .cornerRadius(15.0)
                    
                    Button {
                        withAnimation {
                            gameLogic.level = 2
                            gameLogic.gameState = .playing
                            print(gameLogic.level)
                        }
                    } label: {
                        Text("Play 2")
                            .font(.custom("Chalkduster", size: (UIDevice.current.userInterfaceIdiom == .pad ? 30 : 15)))

                    }
                    .frame(maxWidth: geometry.size.width * 0.1, maxHeight: geometry.size.height * 0.1)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(self.accentColor)
                    .cornerRadius(15.0)
                    
                    Button {
                        withAnimation {
                            gameLogic.level = 3
                            gameLogic.gameState = .playing
                            print(gameLogic.level)
                        }
                    } label: {
                        Text("Play 3")
                            .font(.custom("Chalkduster", size: (UIDevice.current.userInterfaceIdiom == .pad ? 30 : 15)))

                    }
                    .frame(maxWidth: geometry.size.width * 0.1, maxHeight: geometry.size.height * 0.1)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(self.accentColor)
                    .cornerRadius(15.0)
                    
                }
                
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            .statusBar(hidden: true)
        }
    }
    
}


struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectionView(currentGameState: .constant(GameState.mainScreen))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

