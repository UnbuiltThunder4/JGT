//
//  TestScene2.swift
//  Goblin
//
//  Created by Luigi Luca Coletta on 02/05/22.
//

import Foundation
import SpriteKit
import GameplayKit
import SwiftUI
import AVFoundation

class TossScene: SKScene, UIGestureRecognizerDelegate {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    @ObservedObject var population = Population(size: 3, mutationRate: 10)
    @ObservedObject var scrollableMenu: ScrollableMenu = ScrollableMenu()
    @ObservedObject var evilGauge: EvilGauge = EvilGauge(maxFill: MainScreenProperties.maxFill, currentFill: 20,
                                                         size: (UIDevice.current.userInterfaceIdiom == .pad ? GaugeHUDSetting.ipadSize : GaugeHUDSetting.iphoneSize ))
    @ObservedObject var tutorialSheet: TutorialSheet = TutorialSheet()
    @ObservedObject var hud = HUD()
    
    var darkson = DarkSon()
    var enemies: [Enemy] = []
    var structures: [Structure] = []
    
    let background = SKSpriteNode(imageNamed: "forest")
    let trueBackground = SKSpriteNode(imageNamed: "background")
    var effectsMusicPlayer: AVAudioPlayer!
    
    var selectedNode: SKNode?
    var lastSelectedGoblin: SKNode?
    var lastSelectedStructure: SKNode?
    var lastSelectedGnome: SKNode?
    var shootType: GoblinType = .normal
    var touchPoint: CGPoint = CGPoint()
    var panning = false
    var channeling = false
    var paws = false
    var pressed = false
    var isDead = false
    
    let playableRect: CGRect
    let cameraNode = SKCameraNode()
    var lastScale = 1.0
    var currentScale = 1.0
    
    var sheet = Sheet()
    var cauldron = Cauldron(currentGoblinsNumber: 3, maxGoblinNumber: MainScreenProperties.maxGoblinsNumber)
    var evilSight = EvilSight(currentRadius: 1.0, maxRadius: 30.0)
    var pauseScreen = PauseScreen()
    var pauseButton = PauseButton()
    
    let notificationCenter = NotificationCenter.default
    
    var cameraRect: CGRect {
        let x = cameraNode.position.x - size.width/2 + (size.width - playableRect.width)/2
        let y = cameraNode.position.y - size.height/2 + (size.height - playableRect.height)/2
        
        return CGRect(x: x, y: y, width: playableRect.width, height: playableRect.height)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        playableRect = CGRect(x: 0, y: MainScreenProperties.playableMargin, width: UIScreen.main.bounds.width, height: MainScreenProperties.playableHeight)
        
        super.init(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        self.background.name = "background"
        self.background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        self.addChild(background)
        
        self.trueBackground.name = "trueBackground"
        self.trueBackground.anchorPoint = CGPoint(x: 0, y: 0)
        self.trueBackground.position = self.background.position
        trueBackground.zPosition = -2
        self.addChild(trueBackground)
        
        background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
        
        background.physicsBody?.restitution = 0.0
        
        physicsWorld.contactDelegate = self
        
        background.addChild(darkson)
        
        evilSight.position.x = UIScreen.main.bounds.width
        background.addChild(evilSight)
        
        self.enemies.append(contentsOf: gnomes)
        self.structures.append(contentsOf: levelstructures)
        setGoblins(population.goblins, spawnPoint: nil)
        setEnemies(self.enemies)
        setStructures(self.structures)
        
//        switch gameLogic.level {
//        case 1:
//        self.enemies.append(contentsOf: gnomes)
//        self.structures.append(contentsOf: levelstructures)
//        setGoblins(population.goblins, spawnPoint: nil)
//        setEnemies(self.enemies)
//        setStructures(self.structures)
//        case 2:
//            break
//        case 3:
//            break
//        default:
//            break
//        }
        
        
    }
    
    override func didMove(to view: SKView) {
        
        self.view!.isUserInteractionEnabled = true
        
        let panGestureRecognizer = self.setPanGestureRecognizer()
        let tapGestureRecognizer = self.setTapGestureRecognizer()
        let longPressGestureRecognizer = self.setLongPressGestureRecognizer(duration: 0.5)
        let pinchGestureRecognizer = self.setPinchGestureRecognizer()
        
        notificationCenter.addObserver(self, selector: #selector(pauseGame), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        tapGestureRecognizer.require(toFail: panGestureRecognizer)
        tapGestureRecognizer.require(toFail: longPressGestureRecognizer)
        tapGestureRecognizer.require(toFail: pinchGestureRecognizer)
        
        background.addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        
        setupHUD()
        setupCamera()
        
        UserDefaults.standard.set(false, forKey: "goblins101")
        UserDefaults.standard.set(false, forKey: "fireTutorial")
        UserDefaults.standard.set(false, forKey: "treeTutorial")
        UserDefaults.standard.set(false, forKey: "fightTutorial")
        UserDefaults.standard.set(false, forKey: "fearTutorial")
        UserDefaults.standard.set(false, forKey: "frenzyTutorial")
        UserDefaults.standard.set(false, forKey: "academyTutorial")
        UserDefaults.standard.set(false, forKey: "rockTutorial")
        UserDefaults.standard.set(false, forKey: "stoneblinTutorial")
        UserDefaults.standard.set(false, forKey: "gateTutorial")
        UserDefaults.standard.set(false, forKey: "backdoorTutorial")
        UserDefaults.standard.set(false, forKey: "pillagingTutorial")
        UserDefaults.standard.set(false, forKey: "gumblinsTutorial")
        UserDefaults.standard.set(false, forKey: "catapultTutorial")
        UserDefaults.standard.set(false, forKey: "trapTutorial")
        
        player.musicVolume = 0.7
        player.play(music: Audio.MusicFiles.background)
    }
    
    //MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        if paws == false {
            var hasToUpdateRank = false
            
            self.population.goblins.forEach {
                if ($0.update(hud: self.hud)) {
                    hasToUpdateRank = true
                }
                if ($0.health <= 0) {
                    self.cauldron.updateCauldron(amount: -1)
                    self.population.kill($0)
                    if let lastSelected = lastSelectedGoblin {
                        if $0.isEqual(to: lastSelected) {
                            lastSelectedGoblin = nil
                        }
                    }
                }
            }
            if (hasToUpdateRank) {
                self.population.rankPerFitness()
            }
            
            self.enemies.forEach {
                if ($0.update(self)) {
                    let gnomeDeathParticle = SKEmitterNode(fileNamed: "GoblinDeathParticle")
                    gnomeDeathParticle!.position = $0.position
                    gnomeDeathParticle!.name = "goblinDeathParticle"
                    gnomeDeathParticle!.zPosition = 1
                    
                    let parent = $0.parent!.scene!
                    
                    let addDeathParticle = SKAction.run({
                        parent.addChild(gnomeDeathParticle!)
                    })
                    let gnomeDeathFade = SKAction.run {
                        gnomeDeathParticle!.run(SKAction.fadeOut(withDuration: 0.4))
                    }
                    
                    let particleSequence = SKAction.sequence([
                        addDeathParticle,
                        gnomeDeathFade
                    ])
                    
                    let removeDeathParticle = SKAction.run({
                        gnomeDeathParticle!.removeFromParent()
                    })
                    
                    let removeSequence = SKAction.sequence([
                        .wait(forDuration: 0.5),
                        removeDeathParticle
                    ])
                    
                    parent.run(particleSequence)
                    parent.run(removeSequence)
                    
                    let index = self.enemies.firstIndex(of: $0)!
                    $0.removeFromParent()
                    self.enemies.remove(at: index)
                    evilGauge.updateGauge(goblin: nil, value: 5)
                }
            }
            
            if let structure = self.structures[1] as? Gate {
                structure.update(self)
            }
            
            if let structure = self.structures[2] as? Backdoor {
                structure.update(self)
            }
            
            if let structure = self.structures[3] as? Catapult {
                structure.update(self)
            }
            
            if let structure = self.structures[4] as? Trap {
                structure.update(self)
            }
            
            darkson.update(hud: self.hud)
            
            if channeling == true && evilGauge.currentFill > 0 {
                evilGauge.channelingSight()
                evilSight.evilSight(position: self.touchPoint)
                if evilGauge.currentFill == 0 {evilSight.dispatchSight()}
            }
            
            if let lastSelectedGoblin = lastSelectedGoblin as? Goblin {
                sheet.updateSheet(goblin: lastSelectedGoblin)
            } else if let gnomeSelected = lastSelectedGnome as? Enemy {
                sheet.updateSheet(enemy: gnomeSelected)
            } else {
                if let dsSelected = lastSelectedGnome as? DarkSon {
                    sheet.updateSheet(darkSon: dsSelected)
                } else {
                sheet.alpha = 0.0
                }
            }
            
            
            if self.pressed == true && self.isDead == false {
                print(self.pressed)
                if let dyingGoblin = selectedNode as? Goblin {
                    self.isDead = dyingGoblin.pressAnimation()
                } else {
                    //                    selectedNode = nil
                }
            }
            
            if self.evilGauge.currentFill == 0 && self.population.goblins.isEmpty {
                gameLogic.isGameOver = true
            }
            
            gameLogic.finishTheGame(self)
        }
    }
    
}

