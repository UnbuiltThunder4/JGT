//
//  GameOverView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var body: some View {
        ZStack {
            Image("menu-mountains-back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*4)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text("The dark son is dead!")
                    .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 170 : 85)))
                    .foregroundColor(.green)
                    .padding()
                
                HStack {
                    Button {
                        withAnimation { self.backToMainScreen() }
                    } label: {
                        VStack {
                            Text("Main Menu")
                                .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 40)))
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
                                .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 40)))
                                .foregroundColor(.green)
                                .padding()
                            Image("restart-on")
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                }
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

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

