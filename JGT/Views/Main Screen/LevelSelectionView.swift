//
//  MainScreenView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import SwiftUI
import UIKit

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
                        .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 170 : 100)))
                        .foregroundColor(.green)
                        .padding()
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(maxWidth: geometry.size.width * 0.5, maxHeight: (UIDevice.current.userInterfaceIdiom == .pad ? (geometry.size.height * 0.65) : (geometry.size.height * 0.55)))
                            .padding()
                            .foregroundColor(.clear)
                            .cornerRadius(15.0)
                            .overlay {
                                VStack {
                                    Text("\(levelNames[gameLogic.level-1])")
                                        .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 65)))
                                        .foregroundColor(.green)
                                    
                                    Image("menu preview - 1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: UIScreen.main.bounds.width/3, maxHeight: UIScreen.main.bounds.height/1.5)
                                }
                                .padding()
                            }
                        
                        VStack {
                            Button {
                                withAnimation {
                                    gameLogic.gameState = .playing
                                }
                            } label: {
                                Text("Play")
                                    .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 65)))
                                
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
                                    }
                                } label: {
                                    Image("back-button")
                                        .resizable()
                                    
                                }
                                .frame(maxWidth: ((UIDevice.current.userInterfaceIdiom == .pad) ? geometry.size.width * 0.15 : geometry.size.width * 0.1), maxHeight: ((UIDevice.current.userInterfaceIdiom == .pad) ? geometry.size.width * 0.15 : geometry.size.width * 0.1))
                                .padding()
                                .foregroundColor(.white)
                                .background(.clear)
                                .cornerRadius(15.0)
                                
                                Button {
                                    withAnimation {
                                        if gameLogic.level < 3 {
                                            gameLogic.level += 1
                                        }
                                    }
                                } label: {
                                    Image("back-button")
                                        .resizable()
                                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    
                                }
                                .frame(maxWidth: ((UIDevice.current.userInterfaceIdiom == .pad) ? geometry.size.width * 0.15 : geometry.size.width * 0.1), maxHeight: ((UIDevice.current.userInterfaceIdiom == .pad) ? geometry.size.width * 0.15 : geometry.size.width * 0.1))
                                .padding()
                                .foregroundColor(.white)
                                .background(.clear)
                                .cornerRadius(15.0)
                            }
                        }
                        .frame(maxWidth: geometry.size.width * 0.5, maxHeight: geometry.size.height * 0.65)
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
        Group {
            LevelSelectionView()
                .previewInterfaceOrientation(.landscapeLeft)
            LevelSelectionView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

