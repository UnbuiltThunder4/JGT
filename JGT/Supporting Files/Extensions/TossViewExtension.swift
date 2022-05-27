//
//  TossViewExtention.swift
//  JGT
//
//  Created by Eugenio Raja on 11/05/22.
//

import Foundation
import UIKit
import SpriteKit

extension TossScene {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UILongPressGestureRecognizer ||
            otherGestureRecognizer is UILongPressGestureRecognizer {
            return false
            
        }
        if gestureRecognizer is UITapGestureRecognizer &&
            otherGestureRecognizer is UIPinchGestureRecognizer {
            return false
        }
        
        return true
        
    }
    
    @objc func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            panning = true
            
            gameLogic.selectNodeForTouch(self, touchLocation: touchLocation)
            
            if let goblinNode = selectedNode as? Goblin {
                goblinNode.state = .inhand //this will change the update function of the goblin
            }
            
        } else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            self.touchPoint = touchLocation
            
            gameLogic.panForTranslation(self, translation: translation)
            
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            
            
        } else if recognizer.state == .ended {
            panning = false
            
            if let goblinNode = selectedNode as? Goblin {
                goblinNode.state = .flying //this will change the update function of the goblin
            }
            
        }
    }
    
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) -> () {
        if recognizer.state == .ended {
            
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
            gameLogic.selectNodeForTouch(self, touchLocation: touchLocation)
            
            if selectedNode is Cauldron || selectedNode?.name! == "goblinsNumber" {
                gameLogic.shootGoblin(self, node: cameraNode, type: .normal, population: self.population, destination: cameraNode.position)
            }
            
            if selectedNode?.name == "normalLabel" {
                gameLogic.shootGoblin(self, node: cameraNode, type: .normal, population: self.population, destination: cameraNode.position)
                cauldron.closeSpawn()
            }
            if selectedNode?.name == "rockLabel" {
                gameLogic.shootGoblin(self, node: cameraNode, type: .rock, population: self.population, destination: cameraNode.position)
                cauldron.closeSpawn()
            }
            if selectedNode?.name == "flamblingLabel" {
                gameLogic.shootGoblin(self, node: cameraNode, type: .fire, population: self.population, destination: cameraNode.position)
                cauldron.closeSpawn()
            }
            if selectedNode?.name == "gumblingLabel" {
                gameLogic.shootGoblin(self, node: cameraNode, type: .gum, population: self.population, destination: cameraNode.position)
                cauldron.closeSpawn()
            }

            if let goblinNode = selectedNode as? Goblin {
                lastSelectedGoblin = goblinNode
                self.sheet.alpha = 1.0
                self.sheet.updateSheet(goblin: lastSelectedGoblin as! Goblin)
                cauldron.closeSpawn()
            }
            
            if selectedNode?.name! == "background" {
                self.sheet.alpha = 0.0
                cauldron.closeSpawn()
            }
            
        }
    }
    
    @objc func handleLongPressFrom(recognizer: UILongPressGestureRecognizer) -> () {
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
            gameLogic.selectNodeForTouch(self, touchLocation: touchLocation)
            
            if selectedNode?.name! == "goblin" {
                
                if self.evilGauge.currentFill <= 20 {
                    self.evilGauge.updateGauge(goblin: selectedNode as? Goblin, value: nil)
                    print(selectedNode as! Goblin)
                    self.cauldron.updateCauldron(amount: -1)
                }
                population.goblins.remove(at: population.getIndex(of: selectedNode as! Goblin)!)
                if selectedNode!.isEqual(to: lastSelectedGoblin!) {
                    lastSelectedGoblin = nil
                }
                selectedNode!.removeFromParent()
            }
            if selectedNode?.name! == "background" {
                channeling = true
                touchPoint = touchLocation
//                evilGauge.channelingSight(channeling: channeling)
            }
            
            if selectedNode is Cauldron || selectedNode?.name == "goblinsNumber" {
                cauldron.spawnSelection(population: population)
            }
        }
        if recognizer.state == .ended {
            if selectedNode?.name! == "background" {
                channeling = false
                evilSight.dispatchSight()
//                evilGauge.stopChanneling()
            }
        }
    }
    
    @objc func handlePinchFrom(recognizer: UIPinchGestureRecognizer) -> () {
        if panning == false {
            let scale = recognizer.scale
            let minimumZoom = 0.8
            let maximumZoom = 2.0
            
            if recognizer.state == .began {
                self.lastScale = cameraNode.xScale
            }
            
            if recognizer.state == .changed {
                
                let distanceX = min(abs(cameraNode.position.x - self.background.frame.minX),
                                    abs(cameraNode.position.x - self.background.frame.maxX))
                let distanceY = min(abs(cameraNode.position.y - self.background.frame.minY),
                                    abs(cameraNode.position.y - self.background.frame.maxY))
                let minDistanceX = (self.size.width/2 * self.currentScale) - self.background.frame.minX
                let minDistanceY = (self.size.height/2 * self.currentScale) - self.background.frame.minY
                
                cameraNode.xScale = (1.0 / scale) * self.lastScale
                cameraNode.yScale = (1.0 / scale) * self.lastScale
                
                var moveX: CGFloat = 0.0
                var moveY: CGFloat = 0.0
                
                if distanceX <= minDistanceX && cameraNode.xScale != maximumZoom && cameraNode.xScale != minimumZoom {
                    if cameraNode.position.x < self.background.frame.midX {
                        moveX += 30.0
                    } else {
                        moveX -= 30.0
                    }
                }
                if distanceY <= minDistanceY && cameraNode.xScale != maximumZoom && cameraNode.xScale != minimumZoom {
                    if cameraNode.position.y < self.background.frame.midY {
                        moveY += 30.0
                    } else {
                        moveY -= 30.0
                    }
                }
                
                cameraNode.run(SKAction.move(by: CGVector(dx: moveX, dy: moveY), duration: 0.1))
                                
                if (cameraNode.xScale > maximumZoom) && (cameraNode.yScale > maximumZoom) {
                    cameraNode.xScale = maximumZoom
                    cameraNode.yScale = maximumZoom
                }
                if (cameraNode.xScale < minimumZoom) && (cameraNode.yScale < minimumZoom) {
                    cameraNode.xScale = minimumZoom
                    cameraNode.yScale = minimumZoom
                }
                self.currentScale = cameraNode.xScale
            }
        
        }
    }
    
    func setPanGestureRecognizer() -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom(recognizer:)))
        gesture.delegate = self
        self.view!.addGestureRecognizer(gesture)
        return gesture
    }
    
    func setTapGestureRecognizer() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapFrom(recognizer:)))
        gesture.delegate = self
        self.view!.addGestureRecognizer(gesture)
        return gesture
    }
    
    func setLongPressGestureRecognizer(duration: Double) -> UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressFrom(recognizer:)))
        gesture.delegate = self
        self.view!.addGestureRecognizer(gesture)
        gesture.minimumPressDuration = duration
        return gesture
    }
    
    func setPinchGestureRecognizer() -> UIPinchGestureRecognizer {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchFrom(recognizer:)))
        gesture.delegate = self
        self.view!.addGestureRecognizer(gesture)
        return gesture
    }
    
    func setGoblins(_ goblins: [Goblin], spawnPoint: CGPoint?) { //If spawnPoint == nil goblins are not launched (for initial goblins setup)
        for i in 0..<goblins.count {
            if let spawnPoint = spawnPoint {
                goblins[i].position = spawnPoint
            }
            else {
                goblins[i].position = CGPoint(x: Double.random(in: 50...500), y: Double.random(in: 50...300))
            }
            goblins[i].zPosition = 1

            goblins[i].physicsBody = SKPhysicsBody(rectangleOf: goblins[i].size)
            goblins[i].physicsBody?.affectedByGravity = false
            goblins[i].physicsBody?.restitution = 0.0
            goblins[i].physicsBody?.linearDamping = 0.0
            goblins[i].physicsBody?.angularDamping = 0.0
            goblins[i].physicsBody?.allowsRotation = false
            goblins[i].physicsBody?.categoryBitMask = Collision.Masks.goblin.bitmask
            goblins[i].physicsBody?.collisionBitMask = Collision.Masks.building.bitmask | Collision.Masks.gate.bitmask
            goblins[i].physicsBody?.contactTestBitMask = Collision.Masks.enviroment.bitmask | Collision.Masks.enemy.bitmask
            
            background.addChild(goblins[i])
        }
    }
    
    func setEnemies(_ enemies: [Enemy]) {
        for i in 0..<enemies.count {
            enemies[i].zPosition = 1

            enemies[i].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemies[i].size.width*2.5,
                                                                       height: enemies[i].size.height*2.5))
            enemies[i].physicsBody?.affectedByGravity = false
            enemies[i].physicsBody?.restitution = 0.0
            enemies[i].physicsBody?.linearDamping = 0.0
            enemies[i].physicsBody?.angularDamping = 0.0
            enemies[i].physicsBody?.allowsRotation = false
            enemies[i].physicsBody?.categoryBitMask = Collision.Masks.enemy.bitmask
            enemies[i].physicsBody?.collisionBitMask = Collision.Masks.building.bitmask | Collision.Masks.gate.bitmask
            enemies[i].physicsBody?.contactTestBitMask = Collision.Masks.goblin.bitmask | Collision.Masks.enviroment.bitmask
            
            background.addChild(enemies[i])
        }
    }
    
    func setStructures(_ structures: [Structure]) {
        for i in 0..<structures.count {
            structures[i].zPosition = 0
            if (structures[i].type == .passage) {
                structures[i].zPosition = 1
            }

            structures[i].physicsBody = SKPhysicsBody(rectangleOf:
                                                        CGSize(width: structures[i].size.width*structures[i].maskmodX,
                                                               height: structures[i].size.height*structures[i].maskmodY))
            structures[i].physicsBody?.affectedByGravity = false
            structures[i].physicsBody?.restitution = 0.0
            structures[i].physicsBody?.linearDamping = 0.0
            structures[i].physicsBody?.angularDamping = 0.0
            structures[i].physicsBody?.allowsRotation = false
            structures[i].physicsBody?.categoryBitMask = structures[i].mask.bitmask
            if(structures[i].type == .tavern || structures[i].type == .village || structures[i].type == .academy) {
                structures[i].physicsBody?.contactTestBitMask = Collision.Masks.goblin.bitmask
            }
            else if (structures[i].type == .gate) {
                structures[i].physicsBody?.contactTestBitMask = Collision.Masks.darkson.bitmask
            }
            else {
                structures[i].physicsBody?.collisionBitMask = Collision.Masks.goblin.bitmask
            }
            structures[i].physicsBody?.isDynamic = false
            
            background.addChild(structures[i])
        }
    }
    
    func setupHUD() {
      cameraNode.addChild(hud)
        hud.addCauldron(cauldron: cauldron, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width + UIScreen.main.bounds.height/10.5, y: cameraNode.position.y - UIScreen.main.bounds.height + UIScreen.main.bounds.height/10.5))
        hud.addSheet(sheet: sheet, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width/5, y: cameraNode.position.y - UIScreen.main.bounds.height/2))
        hud.addEvilGauge(evilGauge: evilGauge, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width + UIScreen.main.bounds.height/10.5, y: cameraNode.position.y - UIScreen.main.bounds.height + UIScreen.main.bounds.height/5.5))
    }
    
}
