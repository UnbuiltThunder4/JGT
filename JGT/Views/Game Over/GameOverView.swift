//
//  GameOverView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    @State var gameOverString: String = "Game Over"
    
    var body: some View {
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
            
            VStack(alignment: .center) {
                Text("\(gameOverString)")
                    .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 170 : 90)))
                    .foregroundColor(.green)
                    .padding()
                                
                Spacer()
                
                HStack {
                    Button {
                        withAnimation {
                            self.backToMainScreen()
                        }
                    } label: {
                        VStack {
                            Text("Main Menu")
                                .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 55)))
                                .foregroundColor(.green)
                                .padding()
                            
                            Image("menu-on")
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        VStack {
                            Text("Restart")
                                .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 55)))
                                .foregroundColor(.green)
                                .padding()
                            Image("restart-on")
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                }
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
        gameLogic.gameState = .loading
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameOverView()
                .previewInterfaceOrientation(.landscapeLeft)
            GameOverView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

