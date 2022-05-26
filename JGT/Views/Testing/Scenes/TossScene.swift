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
    var evilGauge = EvilGauge(maxFill: MainScreenProperties.maxFill, currentFill: 20)
    var evilSight = SKSpriteNode(imageNamed: "evil sight")
    
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
//        background.physicsBody?.categoryBitMask = Collision.Masks.map.bitmask
//        background.physicsBody?.collisionBitMask = Collision.Masks.goblin.bitmask
//        background.physicsBody?.contactTestBitMask = Collision.Masks.goblin.bitmask
        
        physicsWorld.contactDelegate = self
        
        setGoblins(population.goblins, spawnPoint: nil)
        setEnemies(self.enemies)
        setStructures(self.structures)
        background.addChild(darkson)
        
        evilSight.alpha = 0.0
        evilSight.zPosition = 1
        evilSight.physicsBody = SKPhysicsBody(circleOfRadius: max(evilSight.size.width/2, evilSight.size.height/2))
        evilSight.physicsBody?.isDynamic = false
        evilSight.physicsBody?.categoryBitMask = Collision.Masks.evilSight.bitmask
        evilSight.physicsBody?.contactTestBitMask = Collision.Masks.goblin.bitmask
        evilSight.physicsBody?.collisionBitMask = Collision.Masks.map.bitmask
        evilSight.name = "evilSight"
        
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
        
    }
    
    //MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        
        self.population.update()
                
        self.enemies.forEach {
            if ($0.update()) {
                let index = self.enemies.firstIndex(of: $0)!
                $0.removeFromParent()
                self.enemies.remove(at: index)
                evilGauge.updateGauge(goblin: nil, value: 5)
            }
        }
        
        if let structure = self.structures[3] as? Catapult {
            structure.update(self)
        }
        
        if let structure = self.structures[5] as? Gate {
            structure.update(self)
        }
        
        darkson.update()
        
        if channeling == true && evilGauge.currentFill > 0 {
            evilGauge.updateGauge(goblin: nil, value: -1)
            gameLogic.evilSight(self, position: self.touchPoint)
            if evilGauge.currentFill == 0 {gameLogic.dispatchSight(self)}
        }
        
        if let goblinSelected = selectedNode as? Goblin {
                sheet.updateSheet(goblin: goblinSelected)
        }
    }
    
}
