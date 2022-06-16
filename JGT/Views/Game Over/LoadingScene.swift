//
//  LoadingScene.swift
//  JGT
//
//  Created by Giuseppe Falso on 16/06/22.
//

import SwiftUI

struct LoadingScene: View {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared

    var body: some View {
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
            
            Text("Loading...")
                .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 170 : 90)))
                .foregroundColor(.green)
                .padding()
        }
        .onAppear {
            withAnimation{
                self.gameLogic.gameState = .playing
            }
        }
    }
}

struct LoadingScene_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingScene()
                .previewInterfaceOrientation(.landscapeLeft)
            LoadingScene()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
