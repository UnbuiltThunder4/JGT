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
        if paws == false {
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
                    switch goblinNode.type {
                    case .normal:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: goblinNode,
                                            audio: random == 0 ? Audio.EffectFiles.goblinFly1 : Audio.EffectFiles.goblinFly2, wait: false, muted: gameLogic.muted)
                        break
                    case .fire:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: goblinNode,
                                            audio: random == 0 ? Audio.EffectFiles.flameblinFly1 : Audio.EffectFiles.flameblinFly2, wait: false, muted: gameLogic.muted)
                        
                        break
                    case .rock:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: goblinNode,
                                            audio: random == 0 ? Audio.EffectFiles.stoneblinFly1 : Audio.EffectFiles.stoneblinFly2, wait: false, muted: gameLogic.muted)
                        break
                    case .gum:
                        gameLogic.playSound(node: goblinNode,
                                            audio: Audio.EffectFiles.gumblinFly1, wait: false, muted: gameLogic.muted)
                        break
                    }
                }
            }
        }
    }
    
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) -> () {
        if recognizer.state == .ended {
            
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
            gameLogic.selectNodeForTouch(self, touchLocation: touchLocation)
            
            if let structure = selectedNode as? Structure {
                self.lastSelectedStructure = structure
                self.scrollableMenu.currentStructure = structure.name!
                self.sheet.alpha = 0.0
                self.scrollableMenu.closeMenu()
                self.scrollableMenu.openMenu(structure: structure)
            }
            
            if let goblinRow = selectedNode as? GoblinRow {
                gameLogic.ejectGoblin(scrollableMenu: scrollableMenu, goblinRow: goblinRow, structure: lastSelectedStructure as! Structure)
            }
            
            if selectedNode is Cauldron || selectedNode?.name! == "goblinsNumber" {
                if UserDefaults.standard.bool(forKey: "goblins101") == false {
                    gameLogic.tutorialEvent(index: 0, hud: hud, tutorialSheet: tutorialSheet)
                    UserDefaults.standard.set(true, forKey: "goblins101")
                    hud.counter += 1
                    hud.tutorialCounter.alpha = 1.0
                    hud.tutorialCounter.text = String(hud.counter)
                }
                gameLogic.shootGoblin(self, node: cameraNode, type: shootType, population: self.population, destination: cameraNode.position)
            }
            
            if selectedNode?.name == "normalHead" {
                shootType = .normal
                gameLogic.shootGoblin(self, node: cameraNode, type: .normal, population: self.population, destination: cameraNode.position)
                evilGauge.updateGaugeColor(type: .normal)
                self.cauldron.closeSpawn()
            }
            if selectedNode?.name == "rockHead" {
                shootType = .rock
                gameLogic.shootGoblin(self, node: cameraNode, type: .rock, population: self.population, destination: cameraNode.position)
                evilGauge.updateGaugeColor(type: .rock)
                self.cauldron.closeSpawn()
            }
            if selectedNode?.name == "flameblinHead" {
                shootType = .fire
                gameLogic.shootGoblin(self, node: cameraNode, type: .fire, population: self.population, destination: cameraNode.position)
                evilGauge.updateGaugeColor(type: .fire)
                self.cauldron.closeSpawn()
            }
            if selectedNode?.name == "gumblingHead" {
                shootType = .gum
                gameLogic.shootGoblin(self, node: cameraNode, type: .gum, population: self.population, destination: cameraNode.position)
                self.evilGauge.updateGaugeColor(type: .gum)
                self.cauldron.closeSpawn()
            }
            
            if let goblinNode = selectedNode as? Goblin {
                self.scrollableMenu.alpha = 0.0
                self.lastSelectedGoblin = goblinNode
                self.sheet.alpha = 1.0
                self.sheet.updateSheet(goblin: lastSelectedGoblin as! Goblin)
                self.cauldron.closeSpawn()
            }
            
            if selectedNode?.name! == "background" || selectedNode?.name! == "rock" || selectedNode?.name! == "wall" || selectedNode?.name! == "backdoor-up" {
                self.sheet.alpha = 0.0
                self.scrollableMenu.closeMenu()
                self.scrollableMenu.alpha = 0.0
                self.cauldron.closeSpawn()
            }
            
            if selectedNode?.name! == "PauseBtn" {
                paws = true
                pauseButton.alpha = 0.0
                self.pauseChilds(isPaused: true)
                pauseScreen.alpha = 1.0
                player.pause(music: Audio.MusicFiles.background)
            }
            
            if selectedNode?.name! == "ContinueBtn" {
                paws = false
                pauseScreen.alpha = 0.0
                pauseButton.alpha = 1.0
                pauseChilds(isPaused: false)
                player.resume()
            }
            
            if selectedNode?.name! == "RestartBtn" {
                
            }
            
            if selectedNode?.name! == "musicButton" {
                if player.musicVolume != 0.0 {
                    player.musicVolume = 0.0
                    self.pauseScreen.musicButton.texture = SKTexture(imageNamed: "music-off")
                } else {
                    player.musicVolume = 0.7
                    self.pauseScreen.musicButton.texture = SKTexture(imageNamed: "music-on")
                }
            }
            
            if selectedNode?.name! == "effectButton" {
                if gameLogic.muted == false {
                    self.pauseScreen.effectButton.texture = SKTexture(imageNamed: "effects-off")
                    gameLogic.muted = true
                } else {
                    self.pauseScreen.effectButton.texture = SKTexture(imageNamed: "effects-on")
                    gameLogic.muted = false
                }
            }
            
            if selectedNode?.name! == "tutorialButton" {
                self.tutorialSheet.alpha = 1.0
                if let tutorial = selectedNode as? TutorialButton {
                    paws = true
                    self.tutorialSheet.isMenu = false
                    self.tutorialSheet.backButton.alpha = 0.0
                    self.tutorialSheet.leftTutorial.alpha = 0.0
                    self.tutorialSheet.rightTutorial.alpha = 0.0
                    self.tutorialSheet.tutorialCounterLabel.alpha = 0.0
                    self.pauseChilds(isPaused: true)
                    self.tutorialSheet.tutorialName.text = tutorial.tutorialName
                    self.tutorialSheet.tutorialDesc.text = tutorial.tutorialDesc
                    self.tutorialSheet.screen.texture = tutorial.screen
                    player.musicVolume = 0.3
                    self.hud.counter -= 1
                    self.hud.tutorialCounter.text = String(self.hud.counter)
                    if self.hud.counter == 0 {
                        self.hud.tutorialCounter.alpha = 0.0
                    }
                    else {
                        self.hud.tutorialCounter.alpha = 1.0
                    }
                }
                selectedNode?.removeFromParent()
            }
            
            if selectedNode?.name! == "tutorialSign" || selectedNode?.name! == "screen" ||
                selectedNode?.name! == "tutorialName" || selectedNode?.name! == "tutorialDesc" {
                if !self.tutorialSheet.isMenu {
                    self.tutorialSheet.alpha = 0.0
                    paws = false
                    pauseChilds(isPaused: false)
                    player.musicVolume = 0.7
                }
            }
            
            if selectedNode?.name == "tutorialSheetButton" {
                self.pauseScreen.alpha = 0.0
                self.tutorialSheet.alpha = 1.0
                self.tutorialSheet.backButton.alpha = 1.0
                self.tutorialSheet.rightTutorial.alpha = 1.0
                self.tutorialSheet.tutorialCounterLabel.alpha = 1.0
                self.tutorialSheet.isMenu = true
                self.tutorialSheet.tutorialCounter = 0
                self.tutorialSheet.tutorialName.text = gameLogic.tutorials[0].tutorialName
                self.tutorialSheet.tutorialDesc.text = gameLogic.tutorials[0].tutorialDesc
                self.tutorialSheet.screen.texture = gameLogic.tutorials[0].screen
                self.tutorialSheet.tutorialCounterLabel.text = String("\(self.tutorialSheet.tutorialCounter + 1)/\(gameLogic.tutorials.count)")
                player.musicVolume = 0.3
            }
            
            if selectedNode?.name == "leftTutorial" {
                self.tutorialSheet.tutorialCounter -= 1
                self.tutorialSheet.rightTutorial.alpha = 1.0
                if self.tutorialSheet.tutorialCounter == 0 {
                    self.tutorialSheet.leftTutorial.alpha = 0.0
                }
                self.tutorialSheet.tutorialName.text = gameLogic.tutorials[self.tutorialSheet.tutorialCounter].tutorialName
                self.tutorialSheet.tutorialDesc.text = gameLogic.tutorials[self.tutorialSheet.tutorialCounter].tutorialDesc
                self.tutorialSheet.screen.texture = gameLogic.tutorials[self.tutorialSheet.tutorialCounter].screen
                self.tutorialSheet.tutorialCounterLabel.text = String("\(self.tutorialSheet.tutorialCounter + 1)/\(gameLogic.tutorials.count)")
            }
            
            if selectedNode?.name == "rightTutorial" {
                self.tutorialSheet.tutorialCounter += 1
                self.tutorialSheet.leftTutorial.alpha = 1.0
                if self.tutorialSheet.tutorialCounter == gameLogic.tutorials.count - 1 {
                    self.tutorialSheet.rightTutorial.alpha = 0.0
                }
                self.tutorialSheet.tutorialName.text = gameLogic.tutorials[self.tutorialSheet.tutorialCounter].tutorialName
                self.tutorialSheet.tutorialDesc.text = gameLogic.tutorials[self.tutorialSheet.tutorialCounter].tutorialDesc
                self.tutorialSheet.screen.texture = gameLogic.tutorials[self.tutorialSheet.tutorialCounter].screen
                self.tutorialSheet.tutorialCounterLabel.text = String("\(self.tutorialSheet.tutorialCounter + 1)/\(gameLogic.tutorials.count)")
            }
            
            if selectedNode?.name == "backButton" {
                self.tutorialSheet.isMenu = false
                self.tutorialSheet.alpha = 0.0
                self.pauseScreen.alpha = 1.0
            }
            
        }
    }
    
    @objc func handleLongPressFrom(recognizer: UILongPressGestureRecognizer) -> () {
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
            gameLogic.selectNodeForTouch(self, touchLocation: touchLocation)
            
            if selectedNode?.name! == "goblin" {
                if let lastSelected = lastSelectedGoblin {
                    if selectedNode!.isEqual(to: lastSelected) {
                        lastSelectedGoblin = nil
                    }
                }
                
                self.pressed = true
                
                let dyingGoblin = selectedNode as! Goblin
                switch dyingGoblin.type {
                case .rock:
                    let random = Int.random(in: 0...1)
                    gameLogic.playSound(node: cameraNode, audio: random == 0 ? Audio.EffectFiles.stoneblinPress1 : Audio.EffectFiles.stoneblinPress2, wait: true, muted: gameLogic.muted)
                case .fire:
                    let random = Int.random(in: 0...1)
                    gameLogic.playSound(node: cameraNode, audio: random == 0 ? Audio.EffectFiles.flameblinPress2 : Audio.EffectFiles.flameblinPress3, wait: true, muted: gameLogic.muted)
                case .gum:
                    gameLogic.playSound(node: cameraNode, audio: Audio.EffectFiles.gumblinPress1, wait: true, muted: gameLogic.muted)
                case .normal:
                    gameLogic.playSound(node: cameraNode, audio: Audio.EffectFiles.goblinPress1, wait: true, muted: gameLogic.muted)
                }
                
            }
            if selectedNode?.name! == "background" {
                channeling = true
                touchPoint = touchLocation
            }
            
            if selectedNode is Cauldron || selectedNode?.name == "goblinsNumber" {
                cauldron.spawnSelection(population: population)
            }
        }
        if recognizer.state == .ended {
            
            if selectedNode?.name == "goblin" {
                self.pressed = false
                if self.isDead == false {
                    let goblin = selectedNode as! Goblin
                    goblin.pressCounter = 0
                    goblin.state = .idle
                } else {
                    self.isDead = false
                    if let goblin = selectedNode as? Goblin {
                        //                    population.kill(goblin)
                        population.goblins.remove(at: population.getIndex(of: goblin)!)
                        
                        if self.evilGauge.currentFill <= 20 {
                            self.evilGauge.updateGauge(goblin: goblin, value: nil)
                            self.cauldron.updateCauldron(amount: -1)
                        }
                    }
                }
            }
            
            if selectedNode?.name! == "background" {
                channeling = false
                evilSight.dispatchSight()
                evilGauge.stopChanneling()
            }
        }
    }
    
    @objc func handlePinchFrom(recognizer: UIPinchGestureRecognizer) -> () {
        if panning == false {
            let scale = recognizer.scale
            let minimumZoom = ZoomProperties.minimumZoom
            let maximumZoom = ZoomProperties.maximumZoom
            
            if recognizer.state == .began {
                gameLogic.lastScale = cameraNode.xScale
            }
            
            if recognizer.state == .changed {
                
                let distanceX = min(abs(cameraNode.position.x - self.background.frame.minX),
                                    abs(cameraNode.position.x - self.background.frame.maxX))
                let distanceY = min(abs(cameraNode.position.y - self.background.frame.minY),
                                    abs(cameraNode.position.y - self.background.frame.maxY))
                let minDistanceX = (self.size.width/2 * gameLogic.currentScale) - self.background.frame.minX
                let minDistanceY = (self.size.height/2 * gameLogic.currentScale) - self.background.frame.minY
                
                cameraNode.xScale = (1.0 / scale) * gameLogic.lastScale
                cameraNode.yScale = (1.0 / scale) * gameLogic.lastScale
                
                var moveX: CGFloat = 0.0
                var moveY: CGFloat = 0.0
                
                if distanceX <= minDistanceX && cameraNode.xScale != maximumZoom && cameraNode.xScale != ZoomProperties.minimumZoom {
                    if cameraNode.position.x < self.background.frame.midX {
                        moveX += ZoomProperties.cameraOffsetx
                    } else {
                        moveX -= ZoomProperties.cameraOffsetx
                    }
                }
                if distanceY <= minDistanceY && cameraNode.xScale != maximumZoom && cameraNode.xScale != ZoomProperties.minimumZoom {
                    if cameraNode.position.y < self.background.frame.midY {
                        moveY += ZoomProperties.cameraOffsety
                    } else {
                        moveY -= ZoomProperties.cameraOffsety
                    }
                }
                
                cameraNode.run(SKAction.move(by: CGVector(dx: moveX, dy: moveY), duration: 0.1))
                
                if (cameraNode.xScale > maximumZoom) && (cameraNode.yScale > maximumZoom) {
                    cameraNode.xScale = maximumZoom
                    cameraNode.yScale = maximumZoom
                }
                if (cameraNode.xScale < ZoomProperties.minimumZoom) && (cameraNode.yScale < ZoomProperties.minimumZoom) {
                    cameraNode.xScale = ZoomProperties.minimumZoom
                    cameraNode.yScale = ZoomProperties.minimumZoom
                }
                gameLogic.currentScale = cameraNode.xScale
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
            goblins[i].zPosition = 4
            
            goblins[i].physicsBody = SKPhysicsBody(rectangleOf: goblins[i].size)
            goblins[i].physicsBody?.affectedByGravity = false
            goblins[i].physicsBody?.restitution = 0.0
            goblins[i].physicsBody?.linearDamping = 0.0
            goblins[i].physicsBody?.angularDamping = 0.0
            goblins[i].physicsBody?.allowsRotation = false
            goblins[i].physicsBody?.categoryBitMask = Collision.Masks.goblin.bitmask
            goblins[i].physicsBody?.collisionBitMask = Collision.Masks.building.bitmask | Collision.Masks.gate.bitmask
            goblins[i].physicsBody?.contactTestBitMask = Collision.Masks.enviroment.bitmask | Collision.Masks.meleeEnemy.bitmask | Collision.Masks.rangedEnemy.bitmask
            
            background.addChild(goblins[i])
        }
    }
    
    func setEnemies(_ enemies: [Enemy]) {
        for i in 0..<enemies.count {
            enemies[i].zPosition = 4
            
            enemies[i].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemies[i].size.width*enemies[i].maskmodX,
                                                                       height: enemies[i].size.height*enemies[i].maskmodY))
            enemies[i].physicsBody?.affectedByGravity = false
            enemies[i].physicsBody?.isDynamic = true
            enemies[i].physicsBody?.restitution = 0.0
            enemies[i].physicsBody?.linearDamping = 0.0
            enemies[i].physicsBody?.angularDamping = 0.0
            enemies[i].physicsBody?.allowsRotation = false
            if enemies[i].type == .bow {
//                enemies[i].physicsBody?.isDynamic = false
                enemies[i].physicsBody?.categoryBitMask = Collision.Masks.rangedEnemy.bitmask
                enemies[i].physicsBody?.contactTestBitMask = Collision.Masks.goblin.bitmask | Collision.Masks.enviroment.bitmask
                enemies[i].physicsBody?.collisionBitMask = Collision.Masks.building.bitmask
            } else {
//                enemies[i].physicsBody?.isDynamic = true
                enemies[i].physicsBody?.categoryBitMask = Collision.Masks.meleeEnemy.bitmask
                enemies[i].physicsBody?.contactTestBitMask = Collision.Masks.goblin.bitmask | Collision.Masks.enviroment.bitmask
                enemies[i].physicsBody?.collisionBitMask = Collision.Masks.building.bitmask | Collision.Masks.gate.bitmask
            }
            
            background.addChild(enemies[i])
        }
    }
    
    func setStructures(_ structures: [Structure]) {
        for i in 0..<structures.count {
            structures[i].zPosition = 0
            if (structures[i].type == .passage) {
                structures[i].zPosition = 4
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
        hud.addSheet(sheet: sheet, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width/4.5, y: cameraNode.position.y - UIScreen.main.bounds.height/2))
        hud.addEvilGauge(evilGauge: evilGauge, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width + UIScreen.main.bounds.height/6.5, y: cameraNode.position.y - UIScreen.main.bounds.height + UIScreen.main.bounds.height/2.5))
        evilGauge.zPosition = 80
        hud.addCauldron(cauldron: cauldron, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width + UIScreen.main.bounds.height/6.6, y: cameraNode.position.y - UIScreen.main.bounds.height + UIScreen.main.bounds.height/7.5))
        hud.addScrollableMenu(scrollableMenu: scrollableMenu, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width/4.5, y: cameraNode.position.y - UIScreen.main.bounds.height/2))
        hud.addPauseScreen(pauseScreen: pauseScreen, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width/2, y: cameraNode.position.y - UIScreen.main.bounds.height/2))
        hud.addPauseButton(pauseButton: pauseButton, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width/10, y: cameraNode.position.y - pauseButton.size.height*1.1))
        hud.addTutorialSheet(tutorialSheet: tutorialSheet, position: CGPoint(x: cameraNode.position.x - UIScreen.main.bounds.width/2, y: cameraNode.position.y - UIScreen.main.bounds.height/2))
    }
    
    func setupCamera() {
        switch UIDevice.current.userInterfaceIdiom {
            
        case .phone:
            ZoomProperties.initialScale = 3.0
            ZoomProperties.maximumZoom = 4.0
            ZoomProperties.minimumZoom = 1.5
            ZoomProperties.cameraOffsetx = 90.0
            ZoomProperties.cameraOffsety = 40.0
            ZoomProperties.initialOffsetx = 230.0
            ZoomProperties.initialOffsety = 120.0
            cameraNode.xScale = ZoomProperties.initialScale
            cameraNode.yScale = ZoomProperties.initialScale
            break
        case .pad:
            ZoomProperties.initialScale = 1.0
            ZoomProperties.maximumZoom = 2.0
            ZoomProperties.minimumZoom = 0.8
            ZoomProperties.cameraOffsetx = 50.0
            ZoomProperties.cameraOffsety = 50.0
            ZoomProperties.initialOffsetx = 50.0
            ZoomProperties.initialOffsety = 50.0
            cameraNode.xScale = ZoomProperties.initialScale
            cameraNode.yScale = ZoomProperties.initialScale
            break
        @unknown default:
            break
        }
        
        let distanceX = min(abs(cameraNode.position.x - self.background.frame.minX),
                            abs(cameraNode.position.x - self.background.frame.maxX))
        let distanceY = min(abs(cameraNode.position.y - self.background.frame.minY),
                            abs(cameraNode.position.y - self.background.frame.maxY))
        let minDistanceX = (UIScreen.main.bounds.width/2 * gameLogic.currentScale) - self.background.frame.minX
        let minDistanceY = (UIScreen.main.bounds.height/2 * gameLogic.currentScale) - self.background.frame.minY
        
        cameraNode.xScale = gameLogic.lastScale
        cameraNode.yScale = gameLogic.lastScale
        
        var moveX: CGFloat = 0.0
        var moveY: CGFloat = 0.0
        
        if distanceX <= minDistanceX && cameraNode.xScale != ZoomProperties.maximumZoom && cameraNode.xScale != ZoomProperties.minimumZoom {
            if cameraNode.position.x < self.background.frame.midX {
                moveX += ZoomProperties.initialOffsetx
            } else {
                moveX -= ZoomProperties.initialOffsetx
            }
        }
        if distanceY <= minDistanceY && cameraNode.xScale != ZoomProperties.maximumZoom && cameraNode.xScale != ZoomProperties.minimumZoom {
            if cameraNode.position.y < self.background.frame.midY {
                moveY += ZoomProperties.initialOffsety
            } else {
                moveY -= ZoomProperties.initialOffsety
            }
        }
        
        cameraNode.position.x += moveX
        cameraNode.position.y += moveY
        
        if (cameraNode.xScale > ZoomProperties.maximumZoom) && (cameraNode.yScale > ZoomProperties.maximumZoom) {
            cameraNode.xScale = ZoomProperties.maximumZoom
            cameraNode.yScale = ZoomProperties.maximumZoom
        }
        if (cameraNode.xScale < ZoomProperties.minimumZoom) && (cameraNode.yScale < ZoomProperties.minimumZoom) {
            cameraNode.xScale = ZoomProperties.minimumZoom
            cameraNode.yScale = ZoomProperties.minimumZoom
        }
        gameLogic.currentScale = cameraNode.xScale
    }
    
    @objc func pauseGame() {
        if self.paws == true {
            self.run(SKAction.wait(forDuration: 0.0001)){
                self.pauseChilds(isPaused: true)
            }
            pauseScreen.zPosition = 30
        }
    }
    
    func pauseChilds(isPaused: Bool){
        for child in children {
            child.isPaused = isPaused
        }
    }
    
}
