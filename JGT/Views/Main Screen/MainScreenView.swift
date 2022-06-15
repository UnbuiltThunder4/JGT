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
    var goblins: [SKSpriteNode] = [
        SKSpriteNode(imageNamed: "goblin"),
        SKSpriteNode(imageNamed: "goblin"),
        SKSpriteNode(imageNamed: "goblin")
    ]
    var goblinSpawn: [CGPoint] = [
        CGPoint(),
        CGPoint(),
        CGPoint()
    ]
    var gameTitle = SKSpriteNode(imageNamed: "title")
    
    override func didMove(to view: SKView) {
        self.background.name = "background"
        self.background.size = UIScreen.main.bounds.size
        self.background.anchorPoint = CGPoint(x: 0, y: 0)
        self.background.position = CGPoint(x: 0.0, y: 0.0)
        self.background.zPosition = 1
        self.addChild(background)
        
        self.mountainsBack.name = "mountainsBack"
        self.mountainsBack.size.width = UIScreen.main.bounds.size.width
        self.mountainsBack.size.height = UIScreen.main.bounds.maxY * 0.7
        self.mountainsBack.anchorPoint = CGPoint(x: 0, y: 0)
        self.mountainsBack.position = CGPoint(x: 0.0, y: 0.0)
        self.mountainsBack.zPosition = 2
        self.addChild(mountainsBack)
        
        self.darkLordTower.name = "darkLordTower"
        self.darkLordTower.size = CGSize(width: 300, height: 600)
        self.darkLordTower.anchorPoint = CGPoint(x: 0, y: 0)
        self.darkLordTower.position = CGPoint(x: UIScreen.main.bounds.maxX * 0.05, y: UIScreen.main.bounds.maxY * 0.2)
        self.darkLordTower.zPosition = 2
        self.addChild(darkLordTower)
        
        self.darkLordEye.name = "darkLordEye"
        self.darkLordEye.size = CGSize(width: 119, height: 131)
        self.darkLordEye.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.darkLordEye.position = CGPoint(x: self.darkLordTower.frame.midX, y: self.darkLordTower.frame.maxY * 0.94)
        self.darkLordEye.alpha = 0.0
        self.darkLordEye.zPosition = 5
        self.addChild(darkLordEye)
        
        self.mountainsFront.name = "mountainsFront"
        self.mountainsFront.size.width = UIScreen.main.bounds.size.width
        self.mountainsFront.size.height = UIScreen.main.bounds.maxY * 0.4
        self.mountainsFront.anchorPoint = CGPoint(x: 0, y: 0)
        self.mountainsFront.position = CGPoint(x: 0.0, y: 0.0)
        self.mountainsFront.zPosition = 3
        self.addChild(mountainsFront)
        
        self.ground.name = "ground"
        self.ground.size = UIScreen.main.bounds.size
        self.ground.size.height = UIScreen.main.bounds.maxY * 0.1
        self.ground.anchorPoint = CGPoint(x: 0, y: 0)
        self.ground.position = CGPoint(x: 0.0, y: 0.0)
        self.ground.zPosition = 4
        self.addChild(ground)
        
        for i in 0...2 {
            self.goblins[i].name = "goblin"
            self.goblins[i].size = CGSize(width: 100, height: 100)
            self.goblins[i].anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.goblins[i].position = CGPoint(x: UIScreen.main.bounds.maxX + CGFloat(i*70), y: UIScreen.main.bounds.maxY * 0.1)
            self.goblinSpawn[i] = self.goblins[i].position
            self.goblins[i].zPosition = 4
            self.addChild(self.goblins[i])
        }
        
        self.darkSon.name = "darkSon"
        self.darkSon.size = CGSize(width: 233, height: 333)
        self.darkSon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.darkSon.position = CGPoint(x: UIScreen.main.bounds.maxX, y: UIScreen.main.bounds.maxY * 0.2)
        self.darkSon.zPosition = 4
        self.addChild(darkSon)
        
        self.gameTitle.name = "gameTitle"
        self.gameTitle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.gameTitle.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY * 0.85)
        self.gameTitle.zPosition = 100
        self.addChild(gameTitle)
        
        let endDarkPosition = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY * 0.2)
        
        let endGoblinPosition = CGPoint(x: UIScreen.main.bounds.minX - 100, y: UIScreen.main.bounds.maxY * 0.1)
        
        let darkLordEyeAppear = SKAction.fadeIn(withDuration: 1.0)
        
        let fireParticle = SKEmitterNode(fileNamed: "FireParticle")
        fireParticle!.name = "fireParticle"
        fireParticle!.position = self.darkLordEye.position
        fireParticle!.particleColorSequence = nil
        fireParticle!.particleColorBlendFactor = 1.0
        fireParticle!.particleColor = UIColor(red: 125/255, green: 15/255, blue: 204/255, alpha: 1.0)
        fireParticle!.zPosition = 4
        fireParticle!.particleScaleSpeed = -1.2
        fireParticle!.setScale(2)
        
        let addFireParticle = SKAction.run({
            self.addChild(fireParticle!)
        })
        
        let darkEyeSequence = SKAction.sequence([
            darkLordEyeAppear,
            addFireParticle
        ])
        
        let movingDarkSon = SKAction.move(to: endDarkPosition, duration: 1.0)
        self.darkSon.run(movingDarkSon) {
            self.darkLordEye.run(darkEyeSequence)
            for i in 0...2 {
                let movingGoblin = SKAction.move(to: endGoblinPosition, duration: self.getDuration(pointA: endGoblinPosition, pointB: self.goblinSpawn[i], speed: CGFloat.random(in: 150...250)))
                self.isWalkingAnimation(goblin: self.goblins[i])
                self.shouldFlip(oldPosition: self.goblinSpawn[i], newPosition: endGoblinPosition, node: self.goblins[i])
                self.goblins[i].run(movingGoblin)
            }
        }
    }
    
    private func getDuration(pointA: CGPoint, pointB: CGPoint, speed: CGFloat) -> TimeInterval {
        let xDist = (pointB.x - pointA.x)
        let yDist = (pointB.y - pointA.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist));
        let duration : TimeInterval = TimeInterval(distance/speed)
        return duration
    }

    
    public func isWalkingAnimation(goblin: SKSpriteNode) {
        var walkTextures : [SKTexture] = []
              
        for i in 1...8 {
            walkTextures.append(SKTexture(imageNamed: "normal_walk (\(i))"))
        }
        
        let walkAnimation = SKAction.repeatForever(SKAction.animate(with: walkTextures, timePerFrame: 0.1))
        
        goblin.run(walkAnimation, withKey: "walkAnimation")
    }
    
    public func shouldFlip(oldPosition: CGPoint, newPosition: CGPoint, node: SKSpriteNode) {
        if Int(oldPosition.x) > Int(newPosition.x) {
            node.xScale = -1
        }
        if Int(oldPosition.x) < Int(newPosition.x) {
            node.xScale = 1
        }
    }
    
    public func genocideFunction() {
        if let s = self.view?.scene {
            NotificationCenter.default.removeObserver(self)
                self.children.forEach { bgchild in
                    bgchild.children.forEach { bggrandson in
                        bggrandson.children.forEach { bggrandgrandson in
                            bggrandgrandson.children.forEach { bggrandgrandgrandson in
                                bggrandgrandgrandson.children.forEach { what in
                                    what.removeAllActions()
                                    what.removeFromParent()
                                }
                                bggrandgrandgrandson.removeAllActions()
                                bggrandgrandgrandson.removeFromParent()
                            }
                            bggrandgrandson.removeAllActions()
                            bggrandgrandson.removeFromParent()
                        }
                        bggrandson.removeAllActions()
                        bggrandson.removeFromParent()
                    }
                    bgchild.removeAllActions()
                    bgchild.removeFromParent()
                }
            }
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
    
    @State private var textOpacity = 1.0
    
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
                        self.startGame()
                    } label: {
                        Text("Play")
                            .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 150 : 15)))
                            .opacity(textOpacity)
                            .onAppear{
                                withAnimation{
                                    textOpacity = 0.0
                                }
                            }
                            .animation(Animation.easeInOut(duration:1.5).repeatForever(autoreverses:true))
                        
                    }
                    .frame(maxWidth: geometry.size.width * 0.5, maxHeight: geometry.size.height * 0.3)
                    .padding(5)
                    .foregroundColor(.green)
                    .background(.clear)
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
        self.currentScene.genocideFunction()
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(currentGameState: .constant(GameState.mainScreen))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

