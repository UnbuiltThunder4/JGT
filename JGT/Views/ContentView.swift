//
//  ContentView.swift
//  JGT
//
//  Created by Eugenio Raja on 04/05/22.
//

import SwiftUI
import SpriteKit

/**
 * # ContentView
 *
 *   This view is responsible for managing the states of the game, presenting the proper view.
 **/

struct ContentView: View {
    
    // The navigation of the app is based on the state of the game.
    // Each state presents a different view on the SwiftUI app structure
    @State var currentGameState: GameState = .mainScreen
    
    @State var currentScene: SKScene? = TossScene()
    
    @State var container : SpriteKitContainer?
    
    // The game logic is a singleton object shared among the different views of the application
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared

    var body: some View {
        
        switch gameLogic.gameState {
        case .mainScreen:
            MainScreenView(currentGameState: $currentGameState)
                .onAppear{
                    container = SpriteKitContainer(skScene: $currentScene)
                }
//                .environmentObject(gameLogic)
        
        case .playing:
            TossView(container: $container, currentScene: $currentScene)
//                .environmentObject(gameLogic)
        
        case .gameOver:
            GameOverView(currentScene: $container)
//                .environmentObject(gameLogic)
            
        case .selection:
            LevelSelectionView(currentGameState: $currentGameState)
//                .environmentObject(gameLogic)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
