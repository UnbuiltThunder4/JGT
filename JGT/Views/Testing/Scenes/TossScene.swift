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

class TossScene: SKScene, UIGestureRecognizerDelegate {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    @ObservedObject var population = Population(size: 3, mutationRate: 10)
    
    var darkson = DarkSon()
    var enemies: [Enemy] = []
    var structures: [Structure] = []
    
    let background = SKSpriteNode(imageNamed: "forest")
    
    var selectedNode: SKNode?
    var lastSelectedGoblin: SKNode?
    var touchPoint: CGPoint = CGPoint()
    var panning = false
    var channeling = false
    
    let playableRect: CGRect
    let cameraNode = SKCameraNode()
    var lastScale = 1.0
    var currentScale = 1.0
    
    var hud = HUD()
    var sheet = Sheet()
    var cauldron = Cauldron(currentGoblinsNumber: 3, maxGoblinNumber: MainScreenProperties.maxGoblinsNumber)
    var evilGauge = EvilGauge(maxFill: MainScreenProperties.maxFill, currentFill: 20, size: (UIDevice.current.userInterfaceIdiom == .pad ? GaugeHUDSetting.ipadSize : GaugeHUDSetting.iphoneSize ))
    var evilSight = EvilSight()
    
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
        
        background.addChild(evilSight)
    }
    
    override func didMove(to view: SKView) {
        
        self.view!.isUserInteractionEnabled = true
        
        let panGestureRecognizer = self.setPanGestureRecognizer()
        let tapGestureRecognizer = self.setTapGestureRecognizer()
        let longPressGestureRecognizer = self.setLongPressGestureRecognizer(duration: 0.5)
        let pinchGestureRecognizer = self.setPinchGestureRecognizer()
        
        tapGestureRecognizer.require(toFail: panGestureRecognizer)
        tapGestureRecognizer.require(toFail: longPressGestureRecognizer)
        tapGestureRecognizer.require(toFail: pinchGestureRecognizer)
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        
        setupHUD()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            ZoomProperties.initialScale = 2.0
            ZoomProperties.maximumZoom = 4.0
            ZoomProperties.minimumZoom = 1.5
            cameraNode.xScale = ZoomProperties.initialScale
            cameraNode.yScale = ZoomProperties.initialScale
            cameraNode.position = CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height)
            break
        case .pad:
            ZoomProperties.initialScale = 1.0
            ZoomProperties.maximumZoom = 2.0
            ZoomProperties.minimumZoom = 0.8
            cameraNode.xScale = ZoomProperties.initialScale
            cameraNode.yScale = ZoomProperties.initialScale
            break
        @unknown default:
            break
        }
        
    }
    
    //MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        
        var hasToUpdateRank = false
        
        self.population.goblins.forEach {
            if ($0.update()) {
                hasToUpdateRank = true
            }
            if ($0.health <= 0) {
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

