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
                ZStack {
                    Image("menu-background")
                        .resizable()
                        .ignoresSafeArea()
                    VStack {
                        Spacer()
                        
                        Image("menu-mountains-back")
                            .resizable()
                            .ignoresSafeArea()
                            .frame(maxHeight: UIScreen.main.bounds.maxY * 0.9)
                    }
                    VStack {
                        Spacer()
                        
                        Image("menu-mountains-front")
                            .resizable()
                            .ignoresSafeArea()
                            .frame(maxHeight: UIScreen.main.bounds.maxY * 0.55)
                    }
                }
                
                VStack {
                    Text("Level Selection")
                        .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 170 : 100)))
                        .foregroundColor(.green)
                        .padding()
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: geometry.size.width * 0.5, height: (UIDevice.current.userInterfaceIdiom == .pad ? (geometry.size.height * 0.65) : (geometry.size.height * 0.55)))
                            .padding()
                            .foregroundColor(.clear)
                            .cornerRadius(15.0)
                            .overlay {
                                VStack(spacing: ((UIDevice.current.userInterfaceIdiom == .pad)) ? 50 : 10) {
                                    Text("\(levelNames[gameLogic.level-1])")
                                        .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 90 : 70)))
                                        .foregroundColor(.green)
                                    
                                    Image("menu preview - \(gameLogic.level)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: ((UIDevice.current.userInterfaceIdiom == .pad) ? UIScreen.main.bounds.width/2.5 : UIScreen.main.bounds.width/2.5), maxHeight: ((UIDevice.current.userInterfaceIdiom == .pad) ? UIScreen.main.bounds.width/4 : UIScreen.main.bounds.width/4.8))
                                        .cornerRadius(15)
                                }
                                .padding()
                            }
                        
                        VStack {
                            Button {
                                withAnimation {
                                    //                                    if gameLogic.level != 3 {
                                    gameLogic.gameState = .playing
                                    //                                    }
                                }
                            } label: {
                                Text("Play")
                                    .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 90 : 65)))
                                
                            }
                            .frame(maxWidth: geometry.size.width * 0.15, maxHeight: geometry.size.height * 0.15)
                            .padding()
                            .foregroundColor(.green)
                            .background(.clear)
                            .cornerRadius(15.0)
                            
                            HStack {
                                Button {
                                    if gameLogic.level > 1 {
                                        gameLogic.level -= 1
                                    }
                                } label: {
                                    Image("back-button")
                                        .resizable()
                                        .grayscale((gameLogic.level == 1) ? 1.0 : 0.0)
                                    
                                }
                                .frame(maxWidth: ((UIDevice.current.userInterfaceIdiom == .pad) ? geometry.size.width * 0.15 : geometry.size.width * 0.1), maxHeight: ((UIDevice.current.userInterfaceIdiom == .pad) ? geometry.size.width * 0.15 : geometry.size.width * 0.1))
                                .padding()
                                .foregroundColor(.white)
                                .background(.clear)
                                .cornerRadius(15.0)
                                
                                Button {
                                    if gameLogic.level < 3 {
                                        gameLogic.level += 1
                                    }
                                } label: {
                                    Image("back-button")
                                        .resizable()
                                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                        .grayscale((gameLogic.level == 3) ? 1.0 : 0.0)
                                    
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

