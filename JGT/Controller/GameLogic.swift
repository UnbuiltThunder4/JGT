//
//  GameLogic.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import Foundation
import SpriteKit

class GameLogic: ObservableObject {
    
    // Single instance of the class
    static let shared: GameLogic = GameLogic()
    
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
        
        retval.x = CGFloat(max(retval.x, (tossScene.background.frame.minX + winSize.width/2*tossScene.currentScale)))
        retval.x = CGFloat(min(retval.x, (tossScene.background.frame.maxX - winSize.width/2*tossScene.currentScale)))
        retval.y = CGFloat(max(retval.y, (tossScene.background.frame.minY + winSize.height/2*tossScene.currentScale)))
        retval.y = CGFloat(min(retval.y, (tossScene.background.frame.maxY - winSize.height/2*tossScene.currentScale)))
        
        return retval
    }
    
    func selectNodeForTouch(_ tossScene: TossScene, touchLocation: CGPoint) {
        
        let touchedNode = tossScene.atPoint(touchLocation)
        
        if touchedNode.isEqual(tossScene.cameraNode) {
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
            
        } else {
            
            let aNewPosition = CGPoint(x: tossScene.cameraNode.position.x + (translation.x * -tossScene.currentScale), y: tossScene.cameraNode.position.y - (translation.y * tossScene.currentScale))
            tossScene.cameraNode.position = self.boundLayerPos(tossScene, aNewPosition: aNewPosition)
            tossScene.panning = false
        }
    }
    
    public func friction(node: SKNode) {
        if (node.physicsBody != nil) {
            node.physicsBody!.velocity.dx /= 1.1
            node.physicsBody!.velocity.dy /= 1.1
        }
    }
    
    public func spawnProjectile(_ tossScene: TossScene, spawnPoint: CGPoint, destinationPoint: CGPoint, type: ProjectileType) {
        let proj = Projectile(type: type, x: spawnPoint.x, y: spawnPoint.y, rotation: 0)
        proj.run(SKAction.move(to: CGPoint(x: destinationPoint.x, y: destinationPoint.y), duration: 1.5), withKey: "thrown")
        tossScene.background.addChild(proj)
    }
    
    public func spawnGoblin(_ tossScene: TossScene, population: Population, spawnPoint: CGPoint?) -> Goblin {
        let newGoblin = population.generate(1)
        tossScene.setGoblins(newGoblin, spawnPoint: spawnPoint)
        return newGoblin[0]
    }
    
    public func shootGoblin(_ tossScene: TossScene, node: SKNode, type: GoblinType, population: Population, destination: CGPoint) {
       
        let spawnable = tossScene.evilGauge.checkSpawn(type: type)
        print(spawnable)
        if spawnable && population.goblins.count != MainScreenProperties.maxGoblinsNumber {
            let spawnPoint = CGPoint(x: node.position.x - (tossScene.size.width/2)*tossScene.currentScale + 50, y: node.position.y - (tossScene.size.height/2)*tossScene.currentScale + 50)
            let newGoblin = spawnGoblin(tossScene, population: population, spawnPoint: spawnPoint)
            let distance = CGVector(dx: destination.x - spawnPoint.x, dy: destination.y - spawnPoint.y)
            
            newGoblin.type = type
            newGoblin.state = .launched
            
            switch type {
            case .normal:
                break
            case .fire:
                newGoblin.texture = SKTexture(imageNamed: "fire_goblin")
                break
            case .rock:
                newGoblin.texture = SKTexture(imageNamed: "rock_goblin")
                break
            case .gum:
                newGoblin.texture = SKTexture(imageNamed: "gum_goblin")
                break
            }
            newGoblin.run(SKAction.move(by: distance, duration: 3.0), withKey: "launched")
            
            tossScene.evilGauge.shootGauge(goblin: newGoblin)
            tossScene.cauldron.updateCauldron(amount: 1)
        }
    }
    
    public func evilSight(_ tossScene: TossScene, position: CGPoint) {
        tossScene.evilSight.run(SKAction.scale(by: 1.1, duration: 0.2))
        tossScene.evilSight.position = position
        var frenziedGoblins: [Goblin] = []
        tossScene.background.enumerateChildNodes(withName: "goblin") { node, _ in
            let goblin = node as! Goblin
            if goblin.frame.intersects(tossScene.evilSight.frame) {
                goblin.isFrenzied = true
                frenziedGoblins.append(goblin)
                print(goblin.fullName)
                print(goblin.isFrenzied)
            }
        }
    }
    
    public func dispatchSight(_ tossScene: TossScene) {
        tossScene.evilSight.setScale(1.0)
        tossScene.evilSight.alpha = 0.0
    }
    
}

