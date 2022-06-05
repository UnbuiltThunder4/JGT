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
    @ObservedObject var scrollableMenu: ScrollableMenu = ScrollableMenu.shared
    @ObservedObject var evilGauge: EvilGauge = EvilGauge.shared
    
    var darkson = DarkSon()
    var enemies: [Enemy] = []
    var structures: [Structure] = []
    
    let background = SKSpriteNode(imageNamed: "forest")
    var effectsMusicPlayer: AVAudioPlayer!
    
    var selectedNode: SKNode?
    var lastSelectedGoblin: SKNode?
    var lastSelectedStructure: SKNode?
    var shootType: GoblinType = .normal
    var touchPoint: CGPoint = CGPoint()
    var panning = false
    var channeling = false
    var paws = false
    
    let playableRect: CGRect
    let cameraNode = SKCameraNode()
    var lastScale = 1.0
    var currentScale = 1.0
    
    var hud = HUD()
    var sheet = Sheet()
    var cauldron = Cauldron(currentGoblinsNumber: 3, maxGoblinNumber: MainScreenProperties.maxGoblinsNumber)
//    var evilGauge = EvilGauge(maxFill: MainScreenProperties.maxFill, currentFill: 20, size: (UIDevice.current.userInterfaceIdiom == .pad ? GaugeHUDSetting.ipadSize : GaugeHUDSetting.iphoneSize ))
    var evilSight = EvilSight(currentRadius: 1.0, maxRadius: 26.0)
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
        
        self.enemies.append(contentsOf: gnomes)
        self.structures.append(contentsOf: levelstructures)
        
        super.init(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        self.background.name = "background"
        self.background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        self.addChild(background)
        
        background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
        
        background.physicsBody?.restitution = 0.0
        
        physicsWorld.contactDelegate = self
        
        setGoblins(population.goblins, spawnPoint: nil)
        setEnemies(self.enemies)
        setStructures(self.structures)
        background.addChild(darkson)
        
        evilSight.position.x = UIScreen.main.bounds.width
        background.addChild(evilSight)
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
        
        player.musicVolume = 0.7
//        playBackgroundMusic(filename: "Psycho Katana - Instrumental.wav")
        player.play(music: Audio.MusicFiles.background)
        
        //        for _ in 0..<10 {
        //        structures[5].addGoblin(Goblin(health: 1, attack: 1, wit: NeuralNetwork(
        //            layers: [
        //                DenseLayer(inputSize: 2, neuronsCount: 2, functionRaw: .sigmoid), //INPUTS  1) GOBLIN TYPE          2) OBJECT
        //                DenseLayer(inputSize: 2, neuronsCount: 4, functionRaw: .sigmoid),
        //                DenseLayer(inputSize: 4, neuronsCount: 2, functionRaw: .sigmoid)  //OUTPUTS 1) 1ST INTERACTION      2) 2ND INTERACTION
        //            ]), fear: 1, frenzy: 1, randomGoblin1: "", randomGoblin2: ""))
        //        }
    }
    
    //MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        if paws == false {
           
            self.listener?.position = cameraNode.position
            
            var hasToUpdateRank = false
            
            self.population.goblins.forEach {
                if ($0.update()) {
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
                if ($0.update()) {
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
            
            
            darkson.update()
            
            if channeling == true && evilGauge.currentFill > 0 {
                evilGauge.channelingSight()
                evilSight.evilSight(position: self.touchPoint)
                if evilGauge.currentFill == 0 {evilSight.dispatchSight()}
            }
            
            if let lastSelectedGoblin = lastSelectedGoblin as? Goblin {
                sheet.updateSheet(goblin: lastSelectedGoblin)
            } else {
                sheet.alpha = 0.0
            }
        }
    }
    
}

