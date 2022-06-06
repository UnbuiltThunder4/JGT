//
//  GameLogic.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import Foundation
import SpriteKit
import AVFoundation

class GameLogic: ObservableObject {
    
    // Single instance of the class
    static let shared: GameLogic = GameLogic()
    var lastScale = 1.0
    var currentScale = 1.0
    
    
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
        if spawnable && population.goblins.count < MainScreenProperties.maxGoblinsNumber {
            let spawnPoint = CGPoint(x: node.position.x - (tossScene.size.width/2)*currentScale + 50, y: node.position.y - (tossScene.size.height/2)*currentScale + 50)
            let newGoblin = spawnGoblin(tossScene, population: population, spawnPoint: spawnPoint)
            let distance = CGVector(dx: destination.x - spawnPoint.x, dy: destination.y - spawnPoint.y)
            
            let rotateRight = SKAction.rotate(byAngle: -.pi/4, duration: 0.1)
            let rotateLeft = SKAction.rotate(byAngle: .pi/4, duration: 0.2)
            let rotateAnimation = SKAction.sequence([rotateRight, rotateLeft])
            tossScene.cauldron.run(rotateAnimation)
            
//            player.play(effect: Audio.EffectFiles.cauldronn, node: nil)
            playSound(node: nil, audio: Audio.EffectFiles.cauldronn, wait: false)
            
            newGoblin.type = type
            newGoblin.state = .launched
            
            switch type {
            case .normal:
                let random = Int.random(in: 0...1)
                playSound(node: newGoblin,
                          audio: random == 0 ? Audio.EffectFiles.goblinFly1 : Audio.EffectFiles.goblinFly2, wait: false)
                break
            case .fire:
                let random = Int.random(in: 0...1)
                playSound(node: newGoblin,
                          audio: random == 0 ? Audio.EffectFiles.flameblinFly1 : Audio.EffectFiles.flameblinFly2, wait: false)
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
                          audio: random == 0 ? Audio.EffectFiles.stoneblinFly1 : Audio.EffectFiles.stoneblinFly2, wait: false)
                newGoblin.texture = SKTexture(imageNamed: "rock_goblin")
                break
            case .gum:
                playSound(node: newGoblin,
                          audio: Audio.EffectFiles.gumblinFly1, wait: false)
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
    
    public func playSound(node: SKNode?, audio: Effect, wait: Bool) {
        if let node = node {
            if (node.position.x > (node.parent?.scene?.camera?.position.x)! + UIScreen.main.bounds.width/2 * currentScale ||
                node.position.y > (node.parent?.scene?.camera?.position.y)! + UIScreen.main.bounds.height/2 * currentScale) ||
                (node.position.x < (node.parent?.scene?.camera?.position.x)! - UIScreen.main.bounds.width/2 * currentScale ||
                    node.position.y < (node.parent?.scene?.camera?.position.y)! - UIScreen.main.bounds.height/2 * currentScale) 
            {
                print("mute")
            } else {
        node.run(SKAction.playSoundFileNamed(audio.filename, waitForCompletion: wait))
            }
        } else {
            player.play(effect: audio)
        }
    }
}

