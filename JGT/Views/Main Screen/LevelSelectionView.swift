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
    //    @Binding var currentGameState: GameState
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
            
            ZStack {
                Image("menu-mountains-back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*4)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Level Selection")
                        .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 170 : 85)))
                        .foregroundColor(.green)
                        .padding()
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(maxWidth: geometry.size.width * 0.5, maxHeight: geometry.size.height * 0.65)
                            .padding()
                            .foregroundColor(.clear)
                            .cornerRadius(15.0)
                            .overlay {
                                VStack {
                                    Text("Level \(gameLogic.level)")
                                        .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 55)))
                                        .foregroundColor(.green)
                                    
                                    Image("sheet")
                                        .resizable()
                                        .frame(maxWidth: 400, maxHeight: 400)
                                }
                            }
                        
                        VStack {
                            Button {
                                withAnimation {
//                                    gameLogic.level = 1
                                    gameLogic.gameState = .playing
//                                    print(gameLogic.level)
                                }
                            } label: {
                                Text("Play")
                                    .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 55)))
                                
                            }
                            .frame(maxWidth: geometry.size.width * 0.15, maxHeight: geometry.size.height * 0.15)
                            .padding()
                            .foregroundColor(.green)
                            .background(.clear)
                            .cornerRadius(15.0)
                            
                            HStack {
                                Button {
                                    withAnimation {
                                        if gameLogic.level > 1 {
                                            gameLogic.level -= 1
                                        }
//                                        gameLogic.gameState = .playing
//                                        print(gameLogic.level)
                                    }
                                } label: {
                                    Image("back-button")
                                }
                                .frame(maxWidth: geometry.size.width * 0.15, maxHeight: geometry.size.height * 0.15)
                                .padding()
                                .foregroundColor(.white)
                                .background(.clear)
                                .cornerRadius(15.0)
                                
                                Button {
                                    withAnimation {
                                        if gameLogic.level < 3 {
                                            gameLogic.level += 1
                                        }
//                                        gameLogic.gameState = .playing
//                                        print(gameLogic.level)
                                    }
                                } label: {
                                    Image("back-button")
                                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    
                                }
                                .frame(maxWidth: geometry.size.width * 0.15, maxHeight: geometry.size.height * 0.15)
                                .padding()
                                .foregroundColor(.white)
                                .background(.clear)
                                .cornerRadius(15.0)
                            }
                        }
                        .frame(maxWidth: geometry.size.width * 0.5, maxHeight: geometry.size.height * 0.65)
                        
                        
//                        Button {
//                            withAnimation {
//                                gameLogic.level = 2
//                                gameLogic.gameState = .playing
//                                print(gameLogic.level)
//                            }
//                        } label: {
//                            Text("Level 2")
//                                .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 60 : 35)))
//
//                        }
//                        .frame(maxWidth: geometry.size.width * 0.25, maxHeight: geometry.size.height * 0.3)
//                        .padding(.vertical)
//                        .foregroundColor(.white)
//                        .background(.green)
//                        .cornerRadius(15.0)
//
//                        Button {
//                            withAnimation {
//                                gameLogic.level = 3
//                                gameLogic.gameState = .playing
//                                print(gameLogic.level)
//                            }
//                        } label: {
//                            Text("Level 3")
//                                .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 60 : 35)))
//
//                        }
//                        .frame(maxWidth: geometry.size.width * 0.25, maxHeight: geometry.size.height * 0.3)
//                        .padding(.vertical)
//                        .foregroundColor(.white)
//                        .background(.green)
//                        .cornerRadius(15.0)
                        
                    }
                }
                
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            .statusBar(hidden: true)
        }
    }
    
}


struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

