//
//  MainScreenView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import SwiftUI
import SpriteKit

class MenuScene: SKScene {
    var background = SKSpriteNode(imageNamed: "menu-background")
    var mountainsBack = SKSpriteNode(imageNamed: "menu-mountains-back")
    var darkLordTower = SKSpriteNode(imageNamed: "menu-dark-lord-tower")
    var darkLordEye = SKSpriteNode(imageNamed: "darkLordEye")
    var mountainsFront = SKSpriteNode(imageNamed: "menu-mountains-front")
    var ground = SKSpriteNode(imageNamed: "menu-ground")
    var darkSon = SKSpriteNode(imageNamed: "darkson")
    var gameTitle = SKSpriteNode(imageNamed: "title")
    
    override func didMove(to view: SKView) {
        self.background.name = "background"
        self.background.size = UIScreen.main.bounds.size
        self.background.anchorPoint = CGPoint(x: 0, y: 0)
        self.background.position = CGPoint(x: 0.0, y: 0.0)
        self.addChild(background)
        
        self.mountainsBack.name = "mountainsBack"
        self.mountainsBack.size.width = UIScreen.main.bounds.size.width
        self.mountainsBack.size.height = UIScreen.main.bounds.maxY * 0.7
        self.mountainsBack.anchorPoint = CGPoint(x: 0, y: 0)
        self.mountainsBack.position = CGPoint(x: 0.0, y: 0.0)
        self.addChild(mountainsBack)
        
        self.darkLordTower.name = "darkLordTower"
        self.darkLordTower.size = CGSize(width: 300, height: 600)
        self.darkLordTower.anchorPoint = CGPoint(x: 0, y: 0)
        self.darkLordTower.position = CGPoint(x: UIScreen.main.bounds.maxX * 0.05, y: UIScreen.main.bounds.maxY * 0.2)
        self.addChild(darkLordTower)
        
        self.darkLordEye.name = "darkLordEye"
        self.darkLordEye.size = CGSize(width: 119, height: 131)
        self.darkLordEye.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.darkLordEye.position = CGPoint(x: self.darkLordTower.frame.midX, y: self.darkLordTower.frame.maxY * 0.94)
        self.addChild(darkLordEye)
        
        self.mountainsFront.name = "mountainsFront"
        self.mountainsFront.size.width = UIScreen.main.bounds.size.width
        self.mountainsFront.size.height = UIScreen.main.bounds.maxY * 0.4
        self.mountainsFront.anchorPoint = CGPoint(x: 0, y: 0)
        self.mountainsFront.position = CGPoint(x: 0.0, y: 0.0)
        self.addChild(mountainsFront)
        
        self.ground.name = "ground"
        self.ground.size = UIScreen.main.bounds.size
        self.ground.size.height = UIScreen.main.bounds.maxY * 0.1
        self.ground.anchorPoint = CGPoint(x: 0, y: 0)
        self.ground.position = CGPoint(x: 0.0, y: 0.0)
        self.addChild(ground)
        
        self.darkSon.name = "darkSon"
        self.darkSon.size = CGSize(width: 233, height: 333)
        self.darkSon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.darkSon.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY * 0.85)
        self.addChild(darkSon)
        
        self.gameTitle.name = "gameTitle"
        self.gameTitle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.gameTitle.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY * 0.85)
        self.addChild(gameTitle)
        
    }
}

struct MainScreenView: View {
    @Binding var currentGameState: GameState
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var currentScene = MenuScene()
    
    // Change it on the Constants.swift file
    var gameTitle: String = MainScreenProperties.gameTitle
    
    // Change it on the Constants.swift file
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    // Change it on the Constants.swift file
    let accentColor: Color = MainScreenProperties.accentColor
    
    @State var isPressed: Bool = false
    @State var isPressedFX: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SpriteKitContainer(scene: currentScene)
                    .ignoresSafeArea()
                VStack {
                    
                    //                Button {
                    //
                    //                } label: {
                    //                    Image("info-button")
                    //
                    //                }
                    //                .frame(maxWidth: geometry.size.width * 0.1, maxHeight: geometry.size.height * 0.1)
                    //                .padding(.top)
                    //                .foregroundColor(.white)
                    
                    //                Spacer()
                    
                    Button {
                        withAnimation { self.startGame() }
                    } label: {
                        Text("Play")
                            .font(.custom("Chalkduster", size: (UIDevice.current.userInterfaceIdiom == .pad ? 30 : 15)))
                        
                    }
                    .frame(maxWidth: geometry.size.width * 0.1, maxHeight: geometry.size.height * 0.1)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(15.0)
                    
                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            .statusBar(hidden: true)
            }
        }
    }
    
    private func startGame() {
        print("- Starting the game...")
        gameLogic.gameState = .selection
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(currentGameState: .constant(GameState.mainScreen))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

