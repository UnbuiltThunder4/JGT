//
//  GameLogic.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import Foundation
import SpriteKit
import AVFoundation
import SwiftUI

class GameLogic: ObservableObject {
    @Published var gameState: GameState = .mainScreen
    
    @State var goblins101 = UserDefaults.standard.bool(forKey: "goblins101")
    @State var fireTutorial = UserDefaults.standard.bool(forKey: "fireTutorial")
    @State var rockTutorial = UserDefaults.standard.bool(forKey: "rockTutorial")
    @State var stoneblinTutorial = UserDefaults.standard.bool(forKey: "stoneblinTutorial")
    @State var treeTutorial = UserDefaults.standard.bool(forKey: "treeTutorial")
    @State var fightTutorial = UserDefaults.standard.bool(forKey: "fightTutorial")
    @State var fearTutorial = UserDefaults.standard.bool(forKey: "fearTutorial")
    @State var frenzyTutorial = UserDefaults.standard.bool(forKey: "frenzyTutorial")
    @State var academyTutorial = UserDefaults.standard.bool(forKey: "academyTutorial")
    @State var gateTutorial = UserDefaults.standard.bool(forKey: "gateTutorial")
    @State var backdoorTutorial = UserDefaults.standard.bool(forKey: "backdoorTutorial")
    @State var pillagingTutorial = UserDefaults.standard.bool(forKey: "pillagingTutorial")
    @State var gumblinsTutorial = UserDefaults.standard.bool(forKey: "gumblinsTutorial")
    @State var catapult = UserDefaults.standard.bool(forKey: "catapultTutorial")
    @State var trap = UserDefaults.standard.bool(forKey: "trapTutorial")
    
    // Single instance of the class
    static let shared: GameLogic = GameLogic()
    var muted = false
    var lastScale = ZoomProperties.initialScale
    var currentScale = ZoomProperties.initialScale
    
    var tutorials: [TutorialButton] = [TutorialButton(tutorialName: "Goblins 101", tutorialDesc: """
“My son, by tapping the cauldronn I can summon goblins with the power of evilness alone,
they can help you in many ways, I can throw them by dragging them wherever I want I can long press the terrain to use my evil sight and make them go in a frenzy.
Once I tap on a Goblin I can see all of their stats, in order, I can see their Health, their Attack Power, how much they Fear death, their age, their wit and how long is their frenzy.
If i think some of them are unworthy i can even long press on them to make them explode and get some of my power back.
Remember, the older a goblin I sacrifice, the more evilness I will get back.”
""", screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Lighting Up The Tree", tutorialDesc: """
“Looks like one of our goblins decided to put a tree on fire for no actual reason, this is wonderful!
This act of senseless violence is what we need to gain more power!
I can use the evilness obtained to summon more goblins with the cauldronn.”
""", screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Flameblins", tutorialDesc: """
“Seems like one of our goblins accidentally put himself on flames, since this goblins are made of pure evilness the flames don't burn them but they evolved in a new kind of goblin, the flameblin,
a powerful and reckless fighter, now that i have this new kind of creature i can long press the cauldronn and select it to change the evilness color and summon new flameblin.”
""", screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Fighting", tutorialDesc: """
“Once a goblin gets close enough to an enemy it will ignore everything else and start attacking the enemy, remember that a single goblin is useless, the goblins' power comes in the number.”
""", screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Fear and Tavern", tutorialDesc: """
“Sadly, goblins are cowards. Based on their Fear goblins will try to flee once they get to a certain amount of health left, the tavern is full of potions and beer to help them recover and go back to fight once they’re ready.”
""", screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Frenzy", tutorialDesc: """
                                                      “Be it with the power of my evil sight or the power of the potions in the tavern, goblins can go in frenzy, once in this state their attack power is doubled and they fear nothing, the frenzy is not endless by tapping on a goblin I can see the duration of it’s frenzy.”
                                                      """, screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Academy", tutorialDesc: """
“By attending the Academy, goblins can learn many things, helping them complete tasks in a quicker and more efficient way. once a goblin finishes his studies it gets a title, because it deserves it!”
""", screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Gate", tutorialDesc: """
 “Good work my son, keep attacking the gates, once they’re gone our enemies will have no way to resist, but pay attention!
 If there are no goblins to defend you the risk is death!
 My powers can bring you back but no more than three times so I need to use the goblins to defend you as much as you need.”
 """, screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Backdoor", tutorialDesc: """
                                                      “Our goblins have found a backdoor, once they destroy it they can use the passage to attack enemies on the enemy walls and help you attack the gates without taking any damage.”
                                                      """, screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Rocks", tutorialDesc: """
                                                      “One of our goblins picked up a rock, it can be used in many ways, combat is just one of them.”
                                                      """, screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Stoneblins", tutorialDesc: """
                                                      “Eating a rock has a strange effect on goblins, turning them into Stoneblins, a tougher and dumber kind of Goblin, perfect for combat!”
                                                      """, screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Candyland", tutorialDesc: """
                                                      “One of our goblins entered the gnomes village! There it can make us gain power by stealing candies and bringing chaos!”
                                                      """, screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Gumblins", tutorialDesc: """
 “Eating too many candies can make a goblin evolve into a Gumblin, they act just like normal goblin but their bodies are much more resistant to arrows and practically immune to lightning!”
 """, screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Catapult", tutorialDesc: """
                                                      “The Catapult is a complex siege weapon for goblins, if they understand how to use it our enemies will have no hope of surviving!
                                                      They just need to understand that a normal goblin body is not the best siege ammunition.”
                                                      """, screen: SKTexture(imageNamed: "rockHead")),
                                       TutorialButton(tutorialName: "Trap", tutorialDesc: """
                                                      “The gnomes have started building electric traps to stop our goblins, if they step on one the damage will be really hard for them to survive and the electricity will make them stop for a while, the traps need some time to recharge, we need to exploit that to make our army advance, at all costs!”
                                                      """, screen: SKTexture(imageNamed: "rockHead"))
    ]
    
    // Function responsible to set up the game before it starts.
    func setUpGame() {
        
        // TODO: Customize!
        
        self.currentScore = 0
        self.sessionDuration = 0
        
        self.isGameOver = false
    }
    
    // Keeps track of the current score of the player
    @Published var currentScore: Int = 0
    
    // Increases the score by a certain amount of points
    func score(points: Int) {
        
        // TODO: Customize!
        
        self.currentScore = self.currentScore + points
    }
    
    // Keep tracks of the duration of the current session in number of seconds
    @Published var sessionDuration: TimeInterval = 0
    
    func increaseSessionTime(by timeIncrement: TimeInterval) {
        self.sessionDuration = self.sessionDuration + timeIncrement
    }
    
    func restartGame() {
        
        // TODO: Customize!
        
        self.setUpGame()
    }
    
    // Game Over Conditions
    @Published var isGameOver: Bool = false
    
    func finishTheGame() {
        if self.isGameOver == false {
            self.isGameOver = true
        }
    }
    
    func boundLayerPos(_ tossScene: TossScene, aNewPosition: CGPoint) -> CGPoint {
        let winSize = tossScene.size
        var retval = aNewPosition
        
        retval.x = CGFloat(max(retval.x, (tossScene.background.frame.minX + winSize.width/2*currentScale)))
        retval.x = CGFloat(min(retval.x, (tossScene.background.frame.maxX - winSize.width/2*currentScale)))
        retval.y = CGFloat(max(retval.y, (tossScene.background.frame.minY + winSize.height/2*currentScale)))
        retval.y = CGFloat(min(retval.y, (tossScene.background.frame.maxY - winSize.height/2*currentScale)))
        
        return retval
    }
    
    func selectNodeForTouch(_ tossScene: TossScene, touchLocation: CGPoint) {
        
        let touchedNode = tossScene.atPoint(touchLocation)
        if touchedNode.isEqual(tossScene.cameraNode) || touchedNode is SKEmitterNode {
            tossScene.selectedNode = nil
            return
        }
        
        //        if !tossScene.selectedNode!.isEqual(touchedNode) {
        //            tossScene.selectedNode?.removeAllActions()
        
        tossScene.selectedNode = touchedNode
        
        //        }
        
    }
    
    func panForTranslation(_ tossScene: TossScene, translation: CGPoint) {
        let position = tossScene.selectedNode?.position
        
        if (tossScene.selectedNode?.name!) == "goblin" {
            
            let dt: CGFloat = 1.0/30.0
            let distance = CGVector(dx: tossScene.touchPoint.x - position!.x,
                                    dy: tossScene.touchPoint.y - position!.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            
            if abs(tossScene.touchPoint.x - position!.x) < 10.0 || abs(tossScene.touchPoint.y - position!.y) < 10.0 {
                tossScene.selectedNode?.physicsBody!.velocity = CGVector(dx: 0.0, dy: 0.0)
                tossScene.selectedNode?.position = tossScene.touchPoint
            }
            else {
                tossScene.selectedNode?.physicsBody!.velocity = velocity
            }
            
        } else if (tossScene.selectedNode?.name == "row") && tossScene.scrollableMenu.tableSize > -tossScene.scrollableMenu.contentSection {
            
            tossScene.scrollableMenu.goblinTable.firstRow = tossScene.scrollableMenu.goblinTable.rows[0]
            tossScene.scrollableMenu.goblinTable.lastRow = tossScene.scrollableMenu.goblinTable.rows[tossScene.scrollableMenu.goblinTable.rows.count-1]
            
            let aNewPosition = tossScene.scrollableMenu.goblinTable.position.y + translation.y
            
            if aNewPosition < tossScene.scrollableMenu.goblinTable.position.y && (tossScene.scrollableMenu.goblinTable.firstRow?.position.y)! + tossScene.scrollableMenu.goblinTable.contentOffset > 0 {
                
            tossScene.scrollableMenu.goblinTable.position.y = aNewPosition
            tossScene.scrollableMenu.goblinTable.contentOffset = tossScene.scrollableMenu.goblinTable.position.y
            tossScene.panning = false
                tossScene.scrollableMenu.hideRow()
            } else if aNewPosition > tossScene.scrollableMenu.goblinTable.position.y && (tossScene.scrollableMenu.goblinTable.lastRow?.position.y)! + tossScene.scrollableMenu.goblinTable.contentOffset < tossScene.scrollableMenu.contentSection {
                
                tossScene.scrollableMenu.goblinTable.position.y = aNewPosition
                tossScene.scrollableMenu.goblinTable.contentOffset = tossScene.scrollableMenu.goblinTable.position.y
                tossScene.panning = false
                tossScene.scrollableMenu.hideRow()
            }
            
        } else {
            
            let aNewPosition = CGPoint(x: tossScene.cameraNode.position.x + (translation.x * -currentScale), y: tossScene.cameraNode.position.y - (translation.y * currentScale))
            tossScene.cameraNode.position = self.boundLayerPos(tossScene, aNewPosition: aNewPosition)
            tossScene.panning = false
        }
    }
    
    public func friction(node: SKNode) {
        if (node.physicsBody != nil) {
            if node.physicsBody!.velocity.dx >= 26 {
                node.physicsBody!.velocity.dx /= 1.1
            } else {
                node.physicsBody!.velocity.dx = 0
            }
            
            if node.physicsBody!.velocity.dy >= 26 {
                node.physicsBody!.velocity.dy /= 1.1
            } else {
                node.physicsBody!.velocity.dy = 0
            }
        }
    }
    
    public func spawnProjectile(_ tossScene: TossScene, spawnPoint: CGPoint, destinationPoint: CGPoint, type: ProjectileType) {
        let proj = Projectile(type: type, x: spawnPoint.x, y: spawnPoint.y, rotation: 0)
//        proj.run(SKAction.move(to: CGPoint(x: destinationPoint.x, y: destinationPoint.y), duration: 1.5), withKey: "thrown")
        tossScene.background.addChild(proj)
        
        let distance = CGVector(dx: destinationPoint.x - spawnPoint.x, dy: destinationPoint.y - spawnPoint.y)
        let time = getDuration(distance: distance, speed: proj.speed)
        proj.run(SKAction.move(to: CGPoint(x: destinationPoint.x, y: destinationPoint.y), duration: time), completion: {
            proj.removeAllActions()
            proj.removeFromParent()
        })
    }
    
    public func spawnGoblin(_ tossScene: TossScene, population: Population, spawnPoint: CGPoint?) -> Goblin {
        let newGoblin = population.generate(1)
        tossScene.setGoblins(newGoblin, spawnPoint: spawnPoint)
        return newGoblin[0]
    }
    
    public func shootGoblin(_ tossScene: TossScene, node: SKNode, type: GoblinType, population: Population, destination: CGPoint) {
        
        let spawnable = tossScene.evilGauge.checkSpawn(type: type)
        if spawnable && population.goblins.count < MainScreenProperties.maxGoblinsNumber {
            let spawnPoint = CGPoint(x: node.position.x - (tossScene.size.width/2)*currentScale + 50, y: node.position.y - (tossScene.size.height/2)*currentScale + 50)
            let newGoblin = spawnGoblin(tossScene, population: population, spawnPoint: spawnPoint)
            let distance = CGVector(dx: destination.x - spawnPoint.x, dy: destination.y - spawnPoint.y)
            
            let rotateRight = SKAction.rotate(byAngle: -.pi/4, duration: 0.1)
            let rotateLeft = SKAction.rotate(byAngle: .pi/4, duration: 0.2)
            let rotateAnimation = SKAction.sequence([rotateRight, rotateLeft])
            tossScene.cauldron.run(rotateAnimation)
            
            //            player.play(effect: Audio.EffectFiles.cauldronn, node: nil)
            playSound(node: nil, audio: Audio.EffectFiles.cauldronn, wait: false, muted: muted)
            
            newGoblin.type = type
            newGoblin.state = .launched
            
//            let goblinLaunchedParticle = SKEmitterNode(fileNamed: "SmokeParticle")
//            goblinLaunchedParticle!.position = CGPoint(x: 0, y: 0)
//            goblinLaunchedParticle!.name = "goblinLaunchedParticle"
//            goblinLaunchedParticle!.zPosition = -1
//
//            let addParticle = SKAction.run({
//                newGoblin.addChild(goblinLaunchedParticle!)
//            })
//            let fadeSmoke = SKAction.run {
//                goblinLaunchedParticle!.run(SKAction.fadeOut(withDuration: 0.4))
//            }
//            let removeParticle = SKAction.run({
//                goblinLaunchedParticle!.removeFromParent()
//            })
//
//            let addSequence = SKAction.sequence([
//                addParticle,
//                .wait(forDuration: 0.5),
//                fadeSmoke
//            ])
//
//            newGoblin.run(addSequence, withKey: "goblinLaunchedParticle")
//            
//            let removeSequence = SKAction.sequence([
//                .wait(forDuration: 0.5),
//                removeParticle
//            ])
//            
//            newGoblin.run(removeSequence)
            
            switch type {
            case .normal:
                let random = Int.random(in: 0...1)
                playSound(node: newGoblin,
                          audio: random == 0 ? Audio.EffectFiles.goblinFly1 : Audio.EffectFiles.goblinFly2, wait: false, muted: muted)
                break
            case .fire:
                let random = Int.random(in: 0...1)
                playSound(node: newGoblin,
                          audio: random == 0 ? Audio.EffectFiles.flameblinFly1 : Audio.EffectFiles.flameblinFly2, wait: false, muted: muted)
                newGoblin.fear = 0
                newGoblin.maxFear = 0
                newGoblin.texture = SKTexture(imageNamed: "fire_goblin")
                let flameblinParticle = SKEmitterNode(fileNamed: "FlameblinParticle")
                flameblinParticle!.position = CGPoint(x: 0, y: 0)
                newGoblin.addChild(flameblinParticle!)
                flameblinParticle?.zPosition = -1
                break
            case .rock:
                let random = Int.random(in: 0...1)
                playSound(node: newGoblin,
                          audio: random == 0 ? Audio.EffectFiles.stoneblinFly1 : Audio.EffectFiles.stoneblinFly2, wait: false, muted: muted)
                newGoblin.texture = SKTexture(imageNamed: "rock_goblin")
                break
            case .gum:
                playSound(node: newGoblin,
                          audio: Audio.EffectFiles.gumblinFly1, wait: false, muted: muted)
                newGoblin.texture = SKTexture(imageNamed: "gum_goblin")
                break
            }
            newGoblin.run(SKAction.move(by: distance, duration: 3.0), withKey: "launched")
            
            tossScene.evilGauge.shootGauge(goblin: newGoblin)
            tossScene.cauldron.updateCauldron(amount: 1)
            
        }
    }
    
    public func ejectGoblin(scrollableMenu: ScrollableMenu, goblinRow: GoblinRow, structure: Structure) {
        let strIndex = structure.goblins.firstIndex(where: { $0.id == goblinRow.goblinID})
        structure.goblins[strIndex!].position.y = structure.position.y * 1.5
        structure.goblins[strIndex!].state = .idle
        structure.goblins[strIndex!].alpha = 1.0
        structure.goblins.remove(at: strIndex!)
        scrollableMenu.goblinTable.deleteRow(row: goblinRow, structure: structure)
        scrollableMenu.tableSize -= scrollableMenu.rowsSize.height
        scrollableMenu.hideRow()
    }
    
    public func playSound(node: SKNode?, audio: Effect, wait: Bool, muted: Bool) {
        if !muted {
            if let node = node {
                if let node = node as? Goblin {
                    if node.health > 0 {
                        if (node.position.x > (node.parent?.scene?.camera?.position.x)! + UIScreen.main.bounds.width/2 * currentScale ||
                            node.position.y > (node.parent?.scene?.camera?.position.y)! + UIScreen.main.bounds.height/2 * currentScale) ||
                            (node.position.x < (node.parent?.scene?.camera?.position.x)! - UIScreen.main.bounds.width/2 * currentScale ||
                             node.position.y < (node.parent?.scene?.camera?.position.y)! - UIScreen.main.bounds.height/2 * currentScale)
                        {
                        } else {
                            node.run(SKAction.playSoundFileNamed(audio.filename, waitForCompletion: wait))
                        }
                    }
                } else if (node.position.x > (node.parent?.scene?.camera?.position.x)! + UIScreen.main.bounds.width/2 * currentScale ||
                    node.position.y > (node.parent?.scene?.camera?.position.y)! + UIScreen.main.bounds.height/2 * currentScale) ||
                    (node.position.x < (node.parent?.scene?.camera?.position.x)! - UIScreen.main.bounds.width/2 * currentScale ||
                     node.position.y < (node.parent?.scene?.camera?.position.y)! - UIScreen.main.bounds.height/2 * currentScale)
                {
                } else {
                    node.run(SKAction.playSoundFileNamed(audio.filename, waitForCompletion: wait))
                }
            } else {
                player.play(effect: audio)
            }
        }
    }
    
    public func tutorialEvent(index: Int, hud: HUD, tutorialSheet: TutorialSheet) {
        hud.addTutorialButton(tutorialButton: tutorials[index], position: CGPoint(x: hud.position.x + UIScreen.main.bounds.width/2.5, y: 0))
    }
    
}

