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
//        switch UIDevice.current.userInterfaceIdiom {
//        case .phone:
//            break
//        case .pad:
//            break
//        @unknown default:
//            break
//        }
        
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
        self.darkLordTower.size = CGSize(width: (UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width/5 : UIScreen.main.bounds.width/7), height: UIScreen.main.bounds.height/1.75)
        self.darkLordTower.anchorPoint = CGPoint(x: 0, y: 0)
        self.darkLordTower.position = CGPoint(x: UIScreen.main.bounds.maxX * 0.05, y: UIScreen.main.bounds.maxY * 0.2)
        self.darkLordTower.zPosition = 2
        self.addChild(darkLordTower)
        
        self.darkLordEye.name = "darkLordEye"
        self.darkLordEye.size = CGSize(width: self.darkLordTower.size.width/2.5, height: self.darkLordTower.size.width/2.3)
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
            self.goblins[i].size = CGSize(width: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 70), height: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 70))
            self.goblins[i].anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.goblins[i].position = CGPoint(x: UIScreen.main.bounds.maxX + CGFloat((i+1)*100), y: UIScreen.main.bounds.maxY * 0.1)
            self.goblinSpawn[i] = self.goblins[i].position
            self.goblins[i].zPosition = 4
            self.addChild(self.goblins[i])
        }
        
        self.darkSon.name = "darkSon"
        self.darkSon.size = CGSize(width: (UIDevice.current.userInterfaceIdiom == .pad ? 233 : 117), height: (UIDevice.current.userInterfaceIdiom == .pad ? 333 : 166))
        self.darkSon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.darkSon.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY + 100)
        self.darkSon.zPosition = 4
        self.addChild(darkSon)
        
        self.gameTitle.name = "gameTitle"
        self.gameTitle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.gameTitle.size = CGSize(width: (UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width/1.4 : UIScreen.main.bounds.width/1.5), height: (UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height/6.5 : UIScreen.main.bounds.height/5))
        self.gameTitle.position = CGPoint(x: UIScreen.main.bounds.midX, y: (UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.maxY * 0.85 : UIScreen.main.bounds.maxY * 0.8))
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
        if UIDevice.current.userInterfaceIdiom == .pad  {
            fireParticle!.particleScaleSpeed = -1.2
            fireParticle!.setScale(2)
        } else {
            fireParticle!.particleScaleSpeed = -1.8
            fireParticle!.setScale(1.3)
        }
        
        let addFireParticle = SKAction.run({
            self.addChild(fireParticle!)
        })
        
        let darkEyeSequence = SKAction.sequence([
            darkLordEyeAppear,
            addFireParticle
        ])
        
        let movingDarkSon = SKAction.move(to: endDarkPosition, duration: 1.0)
        self.darkSon.run(movingDarkSon) {
            player.play(music: Audio.MusicFiles.menu)
            player.musicVolume = 0.7
            
            self.darkSon.texture = SKTexture(imageNamed: "attack1")
            
            let fly = SKAction.move(to: CGPoint(x: self.darkSon.position.x, y: self.darkSon.position.y + 10), duration: self.getDuration(pointA: self.darkSon.position, pointB: CGPoint(x: self.darkSon.position.x, y: self.darkSon.position.y + 10), speed: 10))
            
            let flyBack = SKAction.move(to: CGPoint(x: self.darkSon.position.x, y: self.darkSon.position.y - 10), duration: self.getDuration(pointA: self.darkSon.position, pointB: CGPoint(x: self.darkSon.position.x, y: self.darkSon.position.y - 10), speed: 10))
                        
            let flySequence = SKAction.sequence([
                fly,
                flyBack
            ])
            
            let flySequenceForever = SKAction.repeatForever(flySequence)
            
            self.darkSon.run(flySequenceForever)
            
            self.darkLordEye.run(darkEyeSequence) {
                let eyeTextures : [SKTexture] = [
                    SKTexture(imageNamed: "darkLordEye"),
                    SKTexture(imageNamed: "darkLordEye-Left"),
                    SKTexture(imageNamed: "darkLordEye"),
                    SKTexture(imageNamed: "darkLordEye-Right"),
                    SKTexture(imageNamed: "darkLordEye")
                ]
                
                let eyeAnimation = SKAction.animate(with: eyeTextures, timePerFrame: 0.5)
                
                let eyeSequence = SKAction.sequence([
                    eyeAnimation,
                    .wait(forDuration: 2)
                ])
                
                let eyeSequenceAnimation = SKAction.repeatForever(eyeSequence)
                
                self.darkLordEye.run(eyeSequenceAnimation, withKey: "eyeAnimation")
            }
            for i in 0...2 {
                self.moveGoblins(goblin: self.goblins[i], initialGoblinPosition: self.goblinSpawn[i], endGoblinPosition: endGoblinPosition)
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
    
    public func moveGoblins(goblin: SKSpriteNode, initialGoblinPosition: CGPoint, endGoblinPosition: CGPoint) {
        if goblin.position != endGoblinPosition {
            let movingGoblin = SKAction.move(to: endGoblinPosition, duration: self.getDuration(pointA: endGoblinPosition, pointB: initialGoblinPosition, speed: CGFloat.random(in: 200...250)))
            
            self.isWalkingAnimation(goblin: goblin)
            self.shouldFlip(oldPosition: initialGoblinPosition, newPosition: endGoblinPosition, node: goblin)
            goblin.run(movingGoblin) {
                self.moveGoblins(goblin: goblin, initialGoblinPosition: endGoblinPosition, endGoblinPosition: initialGoblinPosition)
            }
        } else {
            let movingGoblin = SKAction.move(to: initialGoblinPosition, duration: self.getDuration(pointA: endGoblinPosition, pointB: initialGoblinPosition, speed: CGFloat.random(in: 150...250)))
            
            self.isWalkingAnimation(goblin: goblin)
            self.shouldFlip(oldPosition: endGoblinPosition, newPosition: initialGoblinPosition, node: goblin)
            goblin.run(movingGoblin) {
                goblin.run(movingGoblin) {
                    self.moveGoblins(goblin: goblin, initialGoblinPosition: initialGoblinPosition, endGoblinPosition: endGoblinPosition)
                }
            }
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

                        Text("Tap to Play")
                            .font(.custom("Nightmare", size: (UIDevice.current.userInterfaceIdiom == .pad ? 100 : 80)))
                            .opacity(textOpacity)
                            .onAppear{
                                withAnimation{
                                    textOpacity = 0.0
                                }
                            }
                            .frame(maxWidth: geometry.size.width * 0.5, maxHeight: geometry.size.height * 0.3)
                            .padding()
                            .foregroundColor(.green)
                            .cornerRadius(15.0)
                            .animation(Animation.easeInOut(duration:1.5).repeatForever(autoreverses:true))

                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            .statusBar(hidden: true)
            }
        }
        .onTapGesture {
            self.startGame()
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

