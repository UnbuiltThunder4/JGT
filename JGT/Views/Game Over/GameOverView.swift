//
//  GameOverView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import SwiftUI

/**
 * # GameOverView
 *   This view is responsible for showing the game over state of the game.
 *  Currently it only present buttons to take the player back to the main screen or restart the game.
 *
 *  You can also present score of the player, present any kind of achievements or rewards the player
 *  might have accomplished during the game session, etc...
 **/

struct GameOverView: View {
    
//    @Binding var currentGameState: GameState
    @Binding var currentScene: SpriteKitContainer?
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Spacer()
                
                Button {
                    withAnimation { self.backToMainScreen() }
                } label: {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.accentColor)
                        .font(.title)
                }
                .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
                
                Spacer()
                
                Button {
                    withAnimation { self.restartGame() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.accentColor)
                        .font(.title)
                }
                .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
                
                Spacer()
            }
        }
        .onAppear{
            print(gameLogic.gameState)
        }
        .statusBar(hidden: true)
    }
    
    private func backToMainScreen() {
        gameLogic.gameState = .mainScreen
    }
    
    private func restartGame() {
        gameLogic.gameState = .playing
    }
}

//struct GameOverView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameOverView(currentGameState: .constant(GameState.gameOver))
//    }
//}

