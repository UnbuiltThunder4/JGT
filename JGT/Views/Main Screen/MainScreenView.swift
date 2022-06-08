//
//  MainScreenView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import SwiftUI

/**
 * # MainScreenView
 *
 *   This view is responsible for presenting the game name, the game intructions and to start the game.
 *  - Customize it as much as you want.
 *  - Experiment with colors and effects on the interface
 *  - Adapt the "Insert a Coin Button" to the visual identity of your game
 **/

struct MainScreenView: View {
    
    // The game state is used to transition between the different states of the game
    @Binding var currentGameState: GameState
    
    // Change it on the Constants.swift file
    var gameTitle: String = MainScreenProperties.gameTitle
    
    // Change it on the Constants.swift file
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    // Change it on the Constants.swift file
    let accentColor: Color = MainScreenProperties.accentColor
    
    var body: some View {
        GeometryReader { geometry in
//            VStack(alignment: .center, spacing: 16.0) {
            VStack {
                /**
                 * # PRO TIP!
                 * The game title can be customized to represent the visual identity of the game
                 */
                Spacer()
                
                Text("\(self.gameTitle)")
    //                .font(.title)
                    .font(.custom("Chalkduster", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 50)))
                    .fontWeight(.black)
                    .padding()
                

                /**
                 * To customize the instructions, check the **Constants.swift** file
                 */
                
                /**
                 * Customize the appearance of the **Insert a Coin** button to match the visual identity of your game
                 */
                Spacer()
                Button {
                    withAnimation { self.startGame() }
                } label: {
                    Text("Play")
                        .font(.custom("Chalkduster", size: (UIDevice.current.userInterfaceIdiom == .pad ? 30 : 15)))
                    
                }
                .frame(maxWidth: geometry.size.width * 0.1, maxHeight: geometry.size.height * 0.1)
                .padding(5)
                .foregroundColor(.white)
                .background(self.accentColor)
                .cornerRadius(15.0)
                
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            .statusBar(hidden: true)
        }
    }
    
    /**
     * Function responsible to start the game.
     * It changes the current game state to present the view which houses the game scene.
     */
    private func startGame() {
        print("- Starting the game...")
        self.currentGameState = .playing
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(currentGameState: .constant(GameState.mainScreen))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

