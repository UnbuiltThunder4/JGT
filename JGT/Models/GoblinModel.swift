
//
//  GoblinModel.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import Foundation
import SwiftUI
import SpriteKit

class Goblin: SKSpriteNode, Identifiable, ObservableObject {
    public let id = UUID()
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    @ObservedObject var evilGauge: EvilGauge = EvilGauge.shared
    @ObservedObject var tutorialSheet: TutorialSheet = TutorialSheet.shared
    
    public var fullName: String
    public let backstory: String
    public var type: GoblinType
    public var age: Int = 0
    private var agecounter: Int = 0
    public var pressCounter: Int = 0
    
    public var isSelected: Bool = false
    public var isGraduated: Bool = false
    public var Proficiencies: [Proficency] = []
    public var state: GoblinState = .idle
    public var fitness: Float = 0
    public var HWpoints: Float = 0 //Points given for task completed (more points for better completion)
    
    public var maxHealth: Int
    public var health: Int
    public var attack: Int
    public var wit = NeuralNetwork(
        layers: [
            DenseLayer(inputSize: 2, neuronsCount: 2, functionRaw: .sigmoid), //INPUTS  1) GOBLIN TYPE          2) OBJECT
            DenseLayer(inputSize: 2, neuronsCount: 4, functionRaw: .sigmoid),
            DenseLayer(inputSize: 4, neuronsCount: 2, functionRaw: .sigmoid)  //OUTPUTS 1) 1ST INTERACTION      2) 2ND INTERACTION
        ])
    public var maxFear: Int
    public var fear: Int
    public var frenzy: Int
    public var currentFrenzyTurn: Int = 0
    public var isFrenzied: Bool = false
    
    public var closeStructure: Structure? = nil
    public var gate: Gate? = nil
    public var hasRock: Bool = false
    
    public var target: Enemy? = nil
    public var targetQueue: [Enemy] = []
    
    private var destination: CGPoint
    private var oldPosition: CGPoint? = nil
    
    private var inVillageCounter: Int = 0
    private var inAcademyCounter: Int = 0
    private var inTavernCounter: Int = 0
    private var frenzyCounter: Int = 0
    private var attackCounter: Int = 0
    private var taskCounter: Int = 0
    private var climbCounter: Int = 0
    private var stunCounter: Int = 0
    private var stuckCounter: Int = 0
    
    private var currentTask: ((HUD, EvilGauge) -> ())? = nil
    private var ignoreThreshold: Float = 0.0
    
    private var goblinTaskTime: Int = taskTime
    
    var actionCloud: SKSpriteNode = SKSpriteNode(imageNamed: "cloud-attack")
    
    init() {
        let goblinname = GoblinConstants.names.randomElement()! + " " + GoblinConstants.surnames.randomElement()!
        self.fullName = goblinname
        self.type = .normal
        let hp = Int.random(in: 10..<101)
        self.maxHealth = hp
        self.health = hp
        self.attack = Int.random(in: 5..<51)
        let fear = Int.random(in: 10..<91)
        self.maxFear = fear
        self.fear = fear
        self.frenzy = Int.random(in: 1..<11)
        self.backstory = GoblinFirstGenDescription.init(name: goblinname).description
        self.destination = CGPoint(
            x: Double.random(in: 60...MainScreenProperties.bgwidth - 60),
            y: Double.random(in: 60...MainScreenProperties.bgheight - 60))
        super.init(texture: SKTexture(imageNamed: "goblin"), color: .red, size: CGSize(width: 100, height: 100))
        self.name = "goblin"
        self.speed = 10.0
        self.actionCloud.position.y = self.frame.height/1.2
        self.actionCloud.position.x = -self.frame.width/4.5
        self.actionCloud.size = CGSize(width: self.size.width, height: self.size.height/1.5)
        self.actionCloud.alpha = 0.0
        self.actionCloud.name = "actionCloud"
        self.addChild(actionCloud)
    }
    
    init(health: Int, attack: Int, wit: NeuralNetwork, fear: Int, frenzy: Int) {
        let goblinname = GoblinConstants.names.randomElement()! + " " + GoblinConstants.surnames.randomElement()!
        self.fullName = goblinname
        self.type = .normal
        self.maxHealth = health
        self.health = health
        self.attack = attack
        self.wit = wit
        self.maxFear = fear
        self.fear = fear
        self.frenzy = frenzy
        self.backstory = GoblinFirstGenDescription.init(name: goblinname).description
        self.destination = CGPoint(
            x: Double.random(in: 60...MainScreenProperties.bgwidth - 60),
            y: Double.random(in: 60...MainScreenProperties.bgheight - 60))
        super.init(texture: SKTexture(imageNamed: "goblin"), color: .red, size: CGSize(width: 100, height: 100))
        self.name = "goblin"
        self.speed = 10.0
        self.actionCloud.position.y = self.frame.height/1.2
        self.actionCloud.position.x = -self.frame.width/4.5
        self.actionCloud.size = CGSize(width: self.size.width, height: self.size.height/1.5)
        self.actionCloud.alpha = 0.0
        self.actionCloud.name = "actionCloud"
        self.addChild(actionCloud)
    }
    
    init(health: Int, attack: Int, wit: NeuralNetwork, fear: Int, frenzy: Int, randomGoblin1: String, randomGoblin2: String) {
        let goblinname = GoblinConstants.names.randomElement()! + " " + GoblinConstants.surnames.randomElement()!
        self.fullName = goblinname
        self.type = .normal
        self.maxHealth = health
        self.health = health
        self.attack = attack
        self.wit = wit
        self.maxFear = fear
        self.fear = fear
        self.frenzy = frenzy
        self.backstory = GoblinDescription.init(name: goblinname, randomGoblin1: randomGoblin1, randomGoblin2: randomGoblin2).description
        self.destination = CGPoint(
            x: Double.random(in: 60...MainScreenProperties.bgwidth - 60),
            y: Double.random(in: 60...MainScreenProperties.bgheight - 60))
        super.init(texture: SKTexture(imageNamed: "goblin"), color: .red, size: CGSize(width: 100, height: 100))
        self.name = "goblin"
        self.speed = 10.0
        self.actionCloud.position.y = self.frame.height/1.2
        self.actionCloud.position.x = -self.frame.width/4.5
        self.actionCloud.size = CGSize(width: self.size.width, height: self.size.height/1.5)
        self.actionCloud.alpha = 0.0
        self.actionCloud.name = "actionCloud"
        self.addChild(actionCloud)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func ==(lhs: Goblin, rhs: Goblin) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func checkStatsCap(_ goblin: Goblin) {
        if (goblin.maxHealth > 100) {
            goblin.maxHealth = 100
        }
        if (goblin.attack > 50) {
            goblin.attack = 50
        }
        if (goblin.maxFear > 90) {
            goblin.maxFear = 90
        }
        if (goblin.frenzy > 10) {
            goblin.frenzy = 10
        }
        if (goblin.maxHealth < 10) {
            goblin.maxHealth = 10
        }
        if (goblin.attack < 5) {
            goblin.attack = 5
        }
        if (goblin.maxFear < 10) {
            goblin.maxFear = 10
        }
        if (goblin.frenzy < 1) {
            goblin.frenzy = 1
        }
    }
    
    public func mutate(goblin: Goblin, mutationRate: Int) {
        if (Int.random(in: 0..<100) < mutationRate) {
            let randnum = Int.random(in: 10..<101)
            goblin.maxHealth = randnum
            goblin.health = randnum
        }
        
        if (Int.random(in: 0..<100) < mutationRate) {
            goblin.attack = Int.random(in: 5..<51)
        }
        
        goblin.wit.mutate(mutationRate: mutationRate)
        
        if (Int.random(in: 0..<100) < mutationRate) {
            goblin.maxFear = Int.random(in: 10..<91)
        }
        
        if (Int.random(in: 0..<100) < mutationRate) {
            goblin.frenzy = Int.random(in: 1..<11)
        }
    }
    
    public func getFitness() -> Float {
        var fit: Float = 0
        
        fit += (Float(self.maxHealth - 10) / 90) * 100
        fit += (Float(self.attack - 5) / 45) * 90
        fit += (Float(self.HWpoints) / Float(self.age)) * 100
        fit += (Float(40 - abs(self.maxFear - 50)) / 40) * 80
        fit += (Float(5 - abs(self.frenzy - 5)) / 5) * 80
        return fit
    }
    
    public func update(hud: HUD, evilGauge: EvilGauge) -> Bool {
        var hasToUpdateRank = false
        
        self.shouldFlip()
        
        switch self.state {
            
        case .idle:
            self.actionCloud.alpha = 0.0
            hasToUpdateRank = idleUpdate(hud)
            break
            
        case .working:
            hasToUpdateRank = workingUpdate(func: self.currentTask, hud: hud, evilGauge: evilGauge)
            break
            
        case .fighting:
            fightingUpdate(hud)
            break
            
        case .feared:
            if UserDefaults.standard.bool(forKey: "fearTutorial") == false {
            gameLogic.tutorialEvent(index: 6, hud: hud, tutorialSheet: tutorialSheet)
                UserDefaults.standard.set(true, forKey: "fearTutorial")
                hud.counter += 1
                hud.tutorialCounter.alpha = 1.0
                hud.tutorialCounter.text = String(hud.counter)
            }
            self.actionCloud.texture = SKTexture(imageNamed: "cloud_fear")
            self.actionCloud.alpha = 1.0
            fearedUpdate()
            break
            
        case .intavern:
            if UserDefaults.standard.bool(forKey: "frenzyTutorial") == false {
            gameLogic.tutorialEvent(index: 7, hud: hud, tutorialSheet: tutorialSheet)
                UserDefaults.standard.set(true, forKey: "frenzyTutorial")
                hud.counter += 1
                hud.tutorialCounter.alpha = 1.0
                hud.tutorialCounter.text = String(hud.counter)
            }
            inTavernUpdate()
            break
            
        case .inacademy:
            hasToUpdateRank = inAcademyUpdate()
            break
            
        case .invillage:
            hasToUpdateRank = inVillageUpdate(hud, evilGauge)
            break
            
        case .intrap:
            hasToUpdateRank = inTrapUpdate(hud)
            break
            
        case .inhand:
            self.actionCloud.alpha = 0.0
            inHandUpdate()
            break
            
        case .backdooring:
            
            if UserDefaults.standard.bool(forKey: "backdoorTutorial") == false {
            gameLogic.tutorialEvent(index: 10, hud: hud, tutorialSheet: tutorialSheet)
                UserDefaults.standard.set(true, forKey: "backdoorTutorial")
                hud.counter += 1
                hud.tutorialCounter.alpha = 1.0
                hud.tutorialCounter.text = String(hud.counter)
            }
            
            backdooringUpdate()
            break
            
        case .passaging:
            passagingUpdate()
            break
            
        case .stunned:
            stunUpdate()
            break
            
        case .flying:
            flyingUpdate()
            break
            
        case .launched:
            launchedUpdate()
            break
            
        default:
            hasToUpdateRank = idleUpdate(hud)
            break
        }
        return hasToUpdateRank
    }
    
    private func idleUpdate(_ hud: HUD) -> Bool {
        var hasToUpdateRank = false
        self.updateAge()
        
        if let _ = self.action(forKey: "walk") {
            if let _ = self.action(forKey: "walkAnimation") {
            }
            else {
                if (targetQueue.isEmpty) {
                    gameLogic.isWalkingAnimation(goblin: self)
                }
            }
        }
        
        if (self.isFrenzied) {
            self.checkFrenzy()
        }
        if (!self.checkFear()) {
            if (self.target == nil) {
                if (!self.targetQueue.isEmpty) {
                    self.target = self.targetQueue[0]
                    self.targetQueue.remove(at: 0)
                }
                else {
                    if let _ = self.action(forKey: "walk") {
                        self.stuckCounter += 1
                        if (self.stuckCounter % fiveSeconds == 0) {
                            self.stuckCounter = 0
                            self.destination = CGPoint(
                                x: Double.random(in: 60...MainScreenProperties.bgwidth - 60),
                                y: Double.random(in: 200...MainScreenProperties.bgheight - 450))
                        }
                        if (self.closeStructure != nil && self.isFrenzied == false) {
                            let targetDistance = CGVector(dx: self.closeStructure!.position.x - self.position.x, dy: self.closeStructure!.position.y - self.position.y)
                            if (isVectorSmallerThan(vector: targetDistance, other: 330)) {
                                if (self.closeStructure!.type == .trap || self.closeStructure!.type == .backdoor || self.closeStructure!.type == .passage) {
                                    hasToUpdateRank = self.checkInterations(input: 0, hud: hud)
                                }
                                if (self.closeStructure!.type != .tavern || !(self.isGraduated && self.closeStructure!.type == .academy)) {
                                    let prediction = self.wit.predict(
                                        input: .init(size: .init(width: 2),
                                                     body: [Float(self.type.rawValue), Float(self.closeStructure!.type.rawValue)]))
                                    var output: Int = 0
                                    if (prediction[0] >= prediction[1]) {
                                        if (prediction[0] > 0.45 - self.ignoreThreshold) {
                                            output = 1
                                        }
                                    }
                                    else {
                                        if (prediction[1] > 0.55 - self.ignoreThreshold) {
                                            output = 2
                                        }
                                    }
                                    if(output > 0) {
                                        self.ignoreThreshold = 0.0
                                        print("action \(output): value \(prediction[output-1])")
                                        hasToUpdateRank = self.checkInterations(input: output, hud: hud)
                                    }
                                    else {
                                        print("ignored")
                                        self.ignoreThreshold += 0.1
                                        self.closeStructure = nil
                                    }
                                }
                            }
                            else {
                                self.closeStructure = nil
                            }
                            self.removeAction(forKey: "walk")
                        }
                    }
                    else {
                        var distance = CGVector(dx: self.destination.x - position.x, dy: self.destination.y - position.y)
                        if (distance.dx > 5.0 || distance.dy > 5.0) {
                            distance = limitVector(vector: distance, max: 100)
                            distance.dx = distance.dx * CGFloat.random(in: 0.2...1.8)
                            distance.dy = distance.dy * CGFloat.random(in: 0.2...1.8)
                        }
                        else {
                            self.destination = CGPoint(
                                x: Double.random(in: 60...MainScreenProperties.bgwidth - 60),
                                y: Double.random(in: 60...MainScreenProperties.bgheight - 900))
                            distance = CGVector(dx: self.destination.x - position.x, dy: self.destination.y - position.y)
                            distance = limitVector(vector: distance, max: 100)
                            distance.dx = distance.dx * CGFloat.random(in: 0.2...1.8)
                            distance.dy = distance.dy * CGFloat.random(in: 0.2...1.8)
                        }
                        let time = getDuration(distance: distance, speed: self.speed)
                        let walk = SKAction.move(by: distance, duration: time)
                        self.run(walk, withKey: "walk")
                    }
                }
            }
            else {
                self.state = .fighting
                removeAction(forKey: "walk")
                gameLogic.removeAnimation(goblin: self)
            }
        }
        else {
            self.state = .feared
            removeAction(forKey: "walk")
        }
        return hasToUpdateRank
    }
    
    private func workingUpdate(func: ((HUD, EvilGauge) -> ())?, hud: HUD, evilGauge: EvilGauge) -> Bool {
        var hasToUpdateRank = false
        if (self.closeStructure!.goblins.isEmpty) {
            self.closeStructure!.goblins.append(self)
            gameLogic.isTaskingAnimation(goblin: self)
        }
        if (self.closeStructure!.goblins.contains(self)) {
            self.target = nil
            self.taskCounter += 1
            
            switch self.closeStructure?.type {
                
            case .tree:
                self.actionCloud.texture = SKTexture(imageNamed: "cloud_tree")
            case .rock:
                self.actionCloud.texture = SKTexture(imageNamed: "cloud_rock")
            case .none:
                break
            case .catapult:
                self.actionCloud.texture = SKTexture(imageNamed: "cloud_catapult")
            case .some(.backdoor):
                break
            case .some(.academy):
                break
            case .some(.village):
                break
            case .some(.tavern):
                break
            case .some(.trap):
                break
            case .some(.gate):
                break
            case .some(.passage):
                break
            case .some(.goblincircle):
                break
            case .some(.wall):
                break
            }
        
            self.actionCloud.alpha = 1.0
            if (self.taskCounter % self.goblinTaskTime == 0) {
                self.currentTask!(hud, evilGauge)
                self.currentTask = nil
                hasToUpdateRank = true
                self.state = .idle
                self.taskCounter = 0
                self.actionCloud.alpha = 0.0
                gameLogic.removeAnimation(goblin: self)
            }
        }
        else {
            self.closeStructure = nil
            self.currentTask = nil
            self.state = .idle
            gameLogic.removeAnimation(goblin: self)
        }
        return hasToUpdateRank
    }
    
    private func fightingUpdate(_ hud: HUD) {
        self.updateAge()
        
        if let _ = self.action(forKey: "walk") {
            gameLogic.removeAnimation(goblin: self)
            gameLogic.isWalkingAnimation(goblin: self)
        }
        else {
            if let _ = self.action(forKey: "attackAnimation") {
            }
            else {
                gameLogic.removeAnimation(goblin: self)
                gameLogic.isFightingAnimation(goblin: self)
            }
        }
        
        if (self.isFrenzied) {
            self.checkFrenzy()
        }
        if (!self.checkFear()) {
            if (self.target != nil) {
                
                self.actionCloud.texture = SKTexture(imageNamed: "cloud_attack")
                self.actionCloud.alpha = 1.0
                
                if UserDefaults.standard.bool(forKey: "fightTutorial") == false {
                gameLogic.tutorialEvent(index: 5, hud: hud, tutorialSheet: tutorialSheet)
                    UserDefaults.standard.set(true, forKey: "fightTutorial")
                    hud.counter += 1
                    hud.tutorialCounter.alpha = 1.0
                    hud.tutorialCounter.text = String(hud.counter)
                }
                
                let targetDistance = CGVector(dx: self.target!.position.x - self.position.x, dy: self.target!.position.y - self.position.y)
                if (isVectorSmallerThan(vector: targetDistance, other: 100)) {
                    removeAction(forKey: "walk")
                    self.attackCounter += 1
                    if (self.attackCounter % attackTime == 0) {
                        
                        switch self.type {
                        case .rock:
                            let random = Int.random(in: 0...1)
                            gameLogic.playSound(node: self, audio:
                                                    random == 0 ? Audio.EffectFiles.stoneblinHit1 : Audio.EffectFiles.stoneblinHit3, wait: false, muted: gameLogic.muted)
                        case .fire:
                            let random = Int.random(in: 0...1)
                            gameLogic.playSound(node: self, audio:
                                                    random == 0 ? Audio.EffectFiles.flameblinHit2 : Audio.EffectFiles.flameblinHit3, wait: false, muted: gameLogic.muted)
                        case .gum:
                            let random = Int.random(in: 0...1)
                            gameLogic.playSound(node: self, audio:
                                                    random == 0 ? Audio.EffectFiles.gumblinHit2 : Audio.EffectFiles.gumblinHit4, wait: false, muted: gameLogic.muted)
                        case .normal:
                            let random = Int.random(in: 0...1)
                            gameLogic.playSound(node: self,
                                                audio: random == 0 ? Audio.EffectFiles.goblinHit1 : Audio.EffectFiles.goblinHit3, wait: false, muted: gameLogic.muted)
                        }
                        
                        var dmg = self.attack
                        if (self.isFrenzied) {
                            dmg += self.attack
                        }
                        self.target!.health -= max(0, dmg - self.target!.shield)
                        self.target!.shield = max(0, self.target!.shield - dmg)
                        if (self.type == .fire) {
                            self.targetQueue.forEach {
                                let aoeDistance = CGVector(dx: $0.position.x - self.position.x, dy: $0.position.y - self.position.y)
                                if (isVectorSmallerThan(vector: aoeDistance, other: 100)) {
                                    $0.health -= max(0, dmg - self.target!.shield)
                                    $0.shield = max(0, self.target!.shield - dmg)
                                    if ($0.health <= 0) {
                                        let index = self.targetQueue.firstIndex(of: $0)!
                                        self.targetQueue.remove(at: index)
                                    }
                                }
                            }
                            let aoeParticle = SKEmitterNode(fileNamed: "ExplosionParticle")
                            aoeParticle!.particleScale *= 2.5
                            aoeParticle!.position = CGPoint(x: 0, y: 0)
                            aoeParticle!.name = "aoeParticle"
                            let addParticle = SKAction.run({
                                self.addChild(aoeParticle!)
                            })
                            let removeParticle = SKAction.run({
                                aoeParticle!.removeFromParent()
                            })
                            
                            let sequence = SKAction.sequence([
                                addParticle,
                                .wait(forDuration: 1.5),
                                removeParticle
                            ])
                            
                            self.run(sequence, withKey: "aoeParticle")
                        }
                        else {
                            let attackParticle = SKEmitterNode(fileNamed: "AttackParticle")
                            attackParticle!.position = CGPoint(x: 0, y: 0)
                            attackParticle!.name = "attackParticle"
                            let addParticle = SKAction.run({
                                self.addChild(attackParticle!)
                            })
                            let removeParticle = SKAction.run({
                                attackParticle!.removeFromParent()
                            })
                            
                            let sequence = SKAction.sequence([
                                addParticle,
                                .wait(forDuration: 0.5),
                                removeParticle
                            ])
                            
                            self.run(sequence, withKey: "attackParticle")
                        }
                        self.attackCounter = 0
                        if (self.target!.target != self) {
                            if (!self.target!.targetQueue.contains(self)) {
                                self.target!.targetQueue.append(self)
                            }
                        }
                    }
                }
                else {
                    let walkDistance = limitVector(vector: targetDistance, max: 50)
                    if let _ = self.action(forKey: "walk") {
                        if (abs(targetDistance.dx) > 300 || abs(targetDistance.dy) > 300) {
                            self.state = .idle
                            self.target = nil
                            gameLogic.removeAnimation(goblin: self)
                            removeAction(forKey: "walk")
                        }
                    }
                    else {
                        let time = getDuration(distance: walkDistance, speed: self.speed)
                        let walk = SKAction.move(by: walkDistance, duration: time)
                        self.run(walk, withKey: "walk")
                    }
                }
                if (self.target != nil) {
                    if (self.target!.health <= 0) {
                        self.actionCloud.alpha = 0.0
                        self.target = nil
                        self.state = .idle
                        gameLogic.removeAnimation(goblin: self)
                        removeAction(forKey: "walk")
                    }
                }
            }
            else {
                self.state = .idle
                gameLogic.removeAnimation(goblin: self)
                removeAction(forKey: "walk")
            }
        }
        else {
            self.state = .feared
            gameLogic.removeAnimation(goblin: self)
            self.target = nil
            self.targetQueue = []
            removeAction(forKey: "walk")
        }
    }
    
    private func fearedUpdate() {
        self.updateAge()
        
        if let _ = self.action(forKey: "run") {
            if let _ = self.action(forKey: "walkAnimation") {
            }
            else {
                gameLogic.isWalkingAnimation(goblin: self)
            }
        }
        
        var tavernDistance = CGVector(dx: tavernCoordinates.x - self.position.x, dy: tavernCoordinates.y - self.position.y)
        if (abs(tavernDistance.dx) < 250 && abs(tavernDistance.dy) < 250) {
            self.actionCloud.alpha = 0.0
            self.enterTavern()
        }
        if let _ = self.action(forKey: "run") {
            if (self.closeStructure != nil) {
                self.stuckCounter += 1
                if (self.stuckCounter % taskTime == 0) {
                    self.stuckCounter = 0
                    self.removeAction(forKey: "run")
                    tavernDistance = CGVector(dx: self.position.x + 500, dy: tavernCoordinates.y - self.position.y)
                    let distance = limitVector(vector: tavernDistance, max: 150)
                    let time = getDuration(distance: distance, speed: self.speed * 2)
                    let run = SKAction.move(by: distance, duration: time)
                    self.run(run, withKey: "run")
                }
                let structureDistance = CGVector(dx: self.closeStructure!.position.x - self.position.x, dy: self.closeStructure!.position.y - self.position.y)
                if (!isVectorSmallerThan(vector: structureDistance, other: 330)) {
                    self.closeStructure = nil
                }
            }
        }
        else {
            var distance = limitVector(vector: tavernDistance, max: 50)
            distance.dx = distance.dx * CGFloat.random(in: 0.2...1.8)
            distance.dy = distance.dy * CGFloat.random(in: 0.2...1.8)
            let time = getDuration(distance: distance, speed: self.speed * 2)
            let run = SKAction.move(by: distance, duration: time)
            self.run(run, withKey: "run")
        }
    }
    
    private func inHandUpdate() {
        self.target = nil
        self.removeAllActions()
        gameLogic.removeAnimation(goblin: self)
    }
    
    private func inTavernUpdate() {
        self.updateAge()
        self.removeAllActions()
        gameLogic.removeAnimation(goblin: self)
        self.inTavernCounter += 1
        if (self.inTavernCounter % self.goblinTaskTime == 0) {
            if (self.currentFrenzyTurn < self.frenzy) {
                self.currentFrenzyTurn += 1
            }
            self.inTavernCounter = 0
            if (self.health + 10 <= self.maxHealth) {
                self.health += 10
            }
            else {
                self.health = self.maxHealth
            }
            if (self.currentFrenzyTurn >= self.frenzy && self.health == self.maxHealth) {
                
                switch self.type {
                case .rock:
                    let random = Int.random(in: 0...1)
                    gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.stoneblinFrenzy1 : Audio.EffectFiles.stoneblinFrenzy2, wait: false, muted: gameLogic.muted)
                case .fire:
                    let random = Int.random(in: 0...1)
                    gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.flameblinFrenzy1 : Audio.EffectFiles.flameblinFrenzy2, wait: false, muted: gameLogic.muted)
                case .gum:
                    gameLogic.playSound(node: self, audio: Audio.EffectFiles.gumblinFrenzy1, wait: false, muted: gameLogic.muted)
                case .normal:
                    gameLogic.playSound(node: self, audio: Audio.EffectFiles.goblinFrenzy1, wait: false, muted: gameLogic.muted)
                }
                
                self.isFrenzied = true
                self.fear = 0
                self.state = .idle
                self.alpha = 1.0
                if let tavern = self.closeStructure as? Tavern {
                    tavern.removeGoblin(self)
                }
                
                let frenzyParticle = SKEmitterNode(fileNamed: "FrenzyParticle")
                frenzyParticle!.name = "frenzyParticle"
                frenzyParticle!.position = CGPoint(x: 0.0, y: 0.0)
                frenzyParticle!.zPosition = -1
                frenzyParticle!.setScale(1.5)
                
                self.addChild(frenzyParticle!)
            }
        }
    }
    
    private func inAcademyUpdate() -> Bool {
        var hasToUpdateRank = false
        self.updateAge()
        self.removeAllActions()
        gameLogic.removeAnimation(goblin: self)
        self.inAcademyCounter += 1
        if (self.inAcademyCounter % structureTime == 0) {
            self.inAcademyCounter = 0
            self.isGraduated = true
            self.goblinTaskTime /= 2
            let temp = self.fullName
            self.fullName = GoblinConstants.honoree.randomElement()! + " " + temp
            self.state = .idle
            
            switch self.type {
            case .rock:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.stoneblinGraduation1 : Audio.EffectFiles.stoneblinGraduation2, wait: false, muted: gameLogic.muted)
            case .fire:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.flameblinGraduation2 : Audio.EffectFiles.flameblinGraduation3, wait: false, muted: gameLogic.muted)
            case .gum:
                gameLogic.playSound(node: self, audio: Audio.EffectFiles.gumblinGraduation1, wait: false, muted: gameLogic.muted)
            case .normal:
                gameLogic.playSound(node: self, audio: Audio.EffectFiles.goblinGraduation1, wait: false, muted: gameLogic.muted)
            }
            
            self.alpha = 1.0
            if let academy = self.closeStructure as? Academy {
                academy.removeGoblin(self)
            }
            self.HWpoints += 100
            self.fitness = self.getFitness()
            hasToUpdateRank = true
        }
        return hasToUpdateRank
    }
    
    private func inVillageUpdate(_ hud: HUD, _ evilGauge: EvilGauge) -> Bool {
        var hasToUpdateRank = false
        self.updateAge()
        self.removeAllActions()
        gameLogic.removeAnimation(goblin: self)
        self.inVillageCounter += 1
        if (self.inVillageCounter % structureTime == 0) {
            //GIVE EVIL POINTS
            self.inVillageCounter = 0
            let randnum = Int.random(in: 0...100)
            if (randnum <= 25 && self.type == .normal) {
                self.state = .idle
                self.alpha = 1.0
                if let village = self.closeStructure as? Village {
                    village.removeGoblin(self)
                }
                self.type = .gum
                self.texture = SKTexture(imageNamed: "gum_goblin")
                self.HWpoints += 150
                self.fitness = self.getFitness()
                hasToUpdateRank = true
                
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self,
                                    audio: random == 0 ? Audio.EffectFiles.gumblinTransform1 : Audio.EffectFiles.gumblinTransform2, wait: false, muted: gameLogic.muted)
                
                if UserDefaults.standard.bool(forKey: "gumblinsTutorial") == false {
                gameLogic.tutorialEvent(index: 14, hud: hud, tutorialSheet: tutorialSheet)
                    UserDefaults.standard.set(true, forKey: "gumblinsTutorial")
                    hud.counter += 1
                    hud.tutorialCounter.alpha = 1.0
                    hud.tutorialCounter.text = String(hud.counter)
                }
                
            }
            else {
                
                switch self.type {
                case .normal:
                    gameLogic.playSound(node: self, audio: Audio.EffectFiles.goblinCandy1, wait: false, muted: gameLogic.muted)
                case .fire:
                    let random = Int.random(in: 0...1)
                    gameLogic.playSound(node: self,
                                        audio: random == 0 ? Audio.EffectFiles.flameblinCandy1 : Audio.EffectFiles.flameblinCandy2, wait: false, muted: gameLogic.muted)
                case .rock:
                    let random = Int.random(in: 0...1)
                    gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.stoneblinCandy1 : Audio.EffectFiles.stoneblinCandy2, wait: false, muted: gameLogic.muted)
                case .gum:
                    break
                }
                
                if UserDefaults.standard.bool(forKey: "pillagingTutorial") == false {
                gameLogic.tutorialEvent(index: 13, hud: hud, tutorialSheet: tutorialSheet)
                    UserDefaults.standard.set(true, forKey: "pillagingTutorial")
                    hud.counter += 1
                    hud.tutorialCounter.alpha = 1.0
                    hud.tutorialCounter.text = String(hud.counter)
                }
                
                evilGauge.updateGauge(goblin: nil, value: 1)
                self.state = .idle
                self.alpha = 1.0
                self.position.x += self.position.x - villageCoordinates.x
                self.position.y += self.position.y - villageCoordinates.y
                if let village = self.closeStructure as? Village {
                    village.removeGoblin(self)
                }
            }
        }
        return hasToUpdateRank
    }
    
    private func inTrapUpdate(_ hud: HUD) -> Bool {
        var hasToUpdateRank = false
        self.updateAge()
        gameLogic.removeAnimation(goblin: self)
        if let trap = self.closeStructure as? Trap {
            if (!trap.isActive) {
                trap.isActive = true
                let closeTrap = SKAction.setTexture(SKTexture(imageNamed: "closed-trap"))
                trap.run(closeTrap)
                if self.health - 80 <= 0 {
                    
                    let goblinDeathParticle = SKEmitterNode(fileNamed: "GoblinDeathParticle")
                    goblinDeathParticle!.position = self.position
                    goblinDeathParticle!.name = "goblinDeathParticle"
                    goblinDeathParticle!.zPosition = 1
                    goblinDeathParticle!.particleColorSequence = nil
                    goblinDeathParticle!.particleColorBlendFactor = 1.0
                    
                    switch self.type {
                    case .rock:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: trap, audio: random == 0 ? Audio.EffectFiles.stoneblinDeath1 : Audio.EffectFiles.stoneblinDeath3, wait: true, muted: gameLogic.muted)
                        goblinDeathParticle!.particleColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0)
                    case .fire:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: trap, audio: random == 0 ? Audio.EffectFiles.flameblinDeath1 : Audio.EffectFiles.flameblinDeath2, wait: true, muted: gameLogic.muted)
                        goblinDeathParticle!.particleColor = UIColor(red: 224/255, green: 53/255, blue: 50/255, alpha: 1.0)
                    case .gum:
                        break
                    case .normal:
                        let random = Int.random(in: 0...1)
                        gameLogic.playSound(node: trap, audio: random == 0 ? Audio.EffectFiles.goblinDeath1 : Audio.EffectFiles.goblinDeath2, wait: true, muted: gameLogic.muted)
                        goblinDeathParticle!.particleColor = UIColor(red: 11/255, green: 129/255, blue: 80/255, alpha: 1.0)
                    }
                    
                    let parent = self.parent!.scene!

                    let addDeathParticle = SKAction.run({
                        parent.addChild(goblinDeathParticle!)
                    })
                    let goblinDeathFade = SKAction.run {
                        goblinDeathParticle!.run(SKAction.fadeOut(withDuration: 0.4))
                    }
                    
                    let particleSequence = SKAction.sequence([
                        addDeathParticle,
                        goblinDeathFade
                    ])

                    let removeDeathParticle = SKAction.run({
                        goblinDeathParticle!.removeFromParent()
                    })

                    let removeSequence = SKAction.sequence([
                        .wait(forDuration: 0.5),
                        removeDeathParticle
                    ])

                    parent.run(particleSequence)
                    parent.run(removeSequence)
                    
                }
                if (self.type != .gum) {
                    self.health -= 80
                    self.HWpoints -= 50
                    self.state = .stunned
                    gameLogic.playSound(node: trap, audio: Audio.EffectFiles.trap, wait: false, muted: gameLogic.muted)
                    
                    let stunParticle = SKEmitterNode(fileNamed: "StunParticle")
                    stunParticle!.name = "stunParticle"
                    stunParticle!.position = CGPoint(x: 0.0, y: 0.0)
                    stunParticle!.zPosition = -1
                    
                    let addStunParticle = SKAction.run {
                        self.addChild(stunParticle!)
                    }
                    let fadeOutStun = SKAction.run {
                        stunParticle!.run(SKAction.fadeOut(withDuration: 2.0))
                    }
                    let removeStun = SKAction.run {
                        stunParticle!.removeFromParent()
                    }
                    
                    let stunSequence = SKAction.sequence([
                        addStunParticle,
                        fadeOutStun,
                    ])
                    
                    self.run(stunSequence, withKey: "StunSequence")
                    
                    let removeSequence = SKAction.sequence([
                        .wait(forDuration: 3),
                        removeStun,
                    ])
                    
                    self.run(removeSequence)
                    
                    if UserDefaults.standard.bool(forKey: "trapTutorial") == false {
                    gameLogic.tutorialEvent(index: 16, hud: hud, tutorialSheet: tutorialSheet)
                        UserDefaults.standard.set(true, forKey: "trapTutorial")
                        hud.counter += 1
                        hud.tutorialCounter.alpha = 1.0
                        hud.tutorialCounter.text = String(hud.counter)
                    }
                    
                }
                else {
                    self.HWpoints += 50
                }
                self.fitness = self.getFitness()
                if (self.health > 0) {
                    hasToUpdateRank = true
                }
            }
        }
        return hasToUpdateRank
    }
    
    private func stunUpdate() {
        self.updateAge()
        self.stunCounter += 1
        if (self.stunCounter % self.goblinTaskTime == 0) {
            self.stunCounter = 0
            self.state = .idle
        }
    }
    
    private func backdooringUpdate() {
        self.updateAge()
        gameLogic.removeAnimation(goblin: self)
        if let _ = self.action(forKey: "attackAnimation") {
        }
        else {
            gameLogic.isFightingAnimation(goblin: self)
        }
        if let backdoor = self.closeStructure as? Backdoor {
            if (backdoor.isOpened) {
                self.alpha = 0.0
                self.climbCounter += 1
                if (self.climbCounter % self.goblinTaskTime == 0) {
                    self.climbCounter = 0
                    self.position.x += abs(self.position.x - passageCoordinates.x) + 50
                    self.position.y += abs(self.position.y - passageCoordinates.y) + 25
                    self.state = .idle
                    self.alpha = 1.0
                    gameLogic.removeAnimation(goblin: self)
                }
            }
            else {
                self.attackCounter += 1
                if (self.attackCounter % attackTime == 0) {
                    self.attackCounter = 0
                    
                    var dmg = self.attack
                    if (self.isFrenzied) {
                        dmg += self.attack
                    }
                    backdoor.health -= dmg
                }
            }
        }
        if (self.target != nil) {
            self.attackCounter = 0
            self.state = .idle
            gameLogic.removeAnimation(goblin: self)
        }
    }
    
    private func passagingUpdate() {
        self.updateAge()
        self.removeAllActions()
        self.alpha = 0.0
        self.climbCounter += 1
        if (self.climbCounter % self.goblinTaskTime == 0) {
            self.climbCounter = 0
            self.position.y = backdoorCoordinates.y - 100
            self.state = .idle
            self.alpha = 1.0
            gameLogic.removeAnimation(goblin: self)
        }
    }
    
    private func flyingUpdate() {
        self.updateAge()
        
        if (self.physicsBody!.velocity.dx != 0 || self.physicsBody!.velocity.dy != 0) {
            gameLogic.friction(node: self)
            if let _ = self.action(forKey: "flyingAnimation") {
                
            } else {
                gameLogic.isFlyingAnimation(goblin: self)
            }
        }
        else {
            self.state = .idle
            
            gameLogic.removeAnimation(goblin: self)
        }
    }
    
    private func launchedUpdate() {
        self.updateAge()
        if let _ = self.action(forKey: "launched") {
            if let _ = self.action(forKey: "flyingAnimation") {
            }
            else {
                gameLogic.isFlyingAnimation(goblin: self)
            }
        }
        else {
            self.state = .idle
            gameLogic.removeAnimation(goblin: self)
        }
    }
    
    private func updateAge() {
        self.agecounter += 1
        if (self.agecounter % ageTime == 0) {
            self.age += 1
            self.agecounter = 0
        }
    }
    
    private func checkFear() -> Bool {
        let percentage = (Double(self.health) / Double(self.maxHealth)) * 100.0
        if (percentage <= Double(self.fear)) {
            switch self.type {
            case .rock:
                gameLogic.playSound(node: self, audio: Audio.EffectFiles.stoneblinFear1, wait: false, muted: gameLogic.muted)
            case .fire:
                break
            case .gum:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self,
                                    audio: random == 0 ? Audio.EffectFiles.gumblinFear2 : Audio.EffectFiles.gumblinFear3, wait: false, muted: gameLogic.muted)
            case .normal:
                gameLogic.playSound(node: self, audio: Audio.EffectFiles.goblinFear1, wait: false, muted: gameLogic.muted)
            }
            return true
        }
        else {
            return false
        }
    }
    
    private func checkFrenzy() {
        if (self.currentFrenzyTurn == 0) {
            self.isFrenzied = false
            self.fear = self.maxFear
            self.removeAllChildren()
        }
        else {
            self.frenzyCounter += 1
            if (self.frenzyCounter % taskTime == 0) {
                self.currentFrenzyTurn -= 1
                self.frenzyCounter = 0
            }
        }
    }
    
    private func checkInterations(input: Int, hud: HUD) -> Bool {
        var hasToUpdateRank = false
        switch self.closeStructure!.type {
            
        case .tavern:
            self.closeStructure = nil
            break
            
        case .academy:
            if (!self.isGraduated) {
                removeAction(forKey: "walk")
                self.enterAcademy(hud)
            }
            else {
                self.closeStructure = nil
            }
            break
            
        case .village:
            if (self.type != .gum) {
                removeAction(forKey: "walk")
                self.enterVillage()
            }
            else {
                self.closeStructure = nil
            }
            break
            
        case .catapult:
            if (input == 2 && self.hasRock == true) {
                removeAction(forKey: "walk")
                if let catapult = self.closeStructure as? Catapult {
                    catapult.texture = SKTexture(imageNamed: "catapult-down")
                }
                self.state = .working
                self.currentTask = self.throwRock
            }
            else if (input == 1) {
                removeAction(forKey: "walk")
                if let catapult = self.closeStructure as? Catapult {
                    catapult.texture = SKTexture(imageNamed: "catapult-down")
                }
                self.state = .working
                self.currentTask = self.throwSelf
            }
            else {
                self.closeStructure = nil
            }
            hasToUpdateRank = true
            break
            
        case .trap:
            removeAction(forKey: "walk")
            self.state = .intrap
            break
            
        case .rock:
            if (input == 1) {
                if (!self.hasRock) {
                    removeAction(forKey: "walk")
                    self.state = .working
                    self.currentTask = self.pickUpRock
                }
                else {
                    self.closeStructure = nil
                }
            }
            else if (input == 2) {
                if (self.type == .normal) {
                    removeAction(forKey: "walk")
                    self.state = .working
                    self.currentTask = self.eatRock
                }
                else {
                    if (!self.hasRock) {
                        removeAction(forKey: "walk")
                        self.state = .working
                        self.currentTask = self.pickUpRock
                    }
                    else {
                        self.closeStructure = nil
                    }
                }
            }
            hasToUpdateRank = true
            break
            
        case .tree:
            if (input == 1) {
                removeAction(forKey: "walk")
                self.state = .working
                self.currentTask = self.setFiretoTree
            }
            else if (input == 2) {
                if (self.type == .normal) {
                    removeAction(forKey: "walk")
                    self.state = .working
                    self.currentTask = self.setFiretoSelf
                }
                else {
                    removeAction(forKey: "walk")
                    self.state = .working
                    self.currentTask = self.setFiretoTree
                }
            }
            hasToUpdateRank = true
            break
            
        case .backdoor:
            removeAction(forKey: "walk")
            self.state = .backdooring
            break
            
        case .passage:
            removeAction(forKey: "walk")
            self.state = .passaging
            break
            
        default:
            break
            
        }
        return hasToUpdateRank
    }
    
    private func enterAcademy(_ hud: HUD) {
        self.state = .inacademy
        self.alpha = 0.0
        if let academy = self.closeStructure as? Academy {
            
            if UserDefaults.standard.bool(forKey: "academyTutorial") == false {
            gameLogic.tutorialEvent(index: 8, hud: hud, tutorialSheet: tutorialSheet)
                UserDefaults.standard.set(true, forKey: "academyTutorial")
                hud.counter += 1
                hud.tutorialCounter.alpha = 1.0
                hud.tutorialCounter.text = String(hud.counter)
            }
            
            academy.addGoblin(self)
        }
    }
    
    private func enterTavern() {
        self.removeAllActions()
        gameLogic.removeAnimation(goblin: self)
        self.state = .intavern
        self.alpha = 0.0
        if let tavern = self.closeStructure as? Tavern {
            tavern.addGoblin(self)
        }
    }
    
    private func enterVillage() {
        self.state = .invillage
        self.alpha = 0.0
        gameLogic.removeAnimation(goblin: self)
        if let village = self.closeStructure as? Village {
            village.addGoblin(self)
        }
    }
    
    private func throwRock(hud: HUD, _ evilGauge: EvilGauge) {
        
        switch self.type {
        case .rock:
            break
        case .fire:
            let random = Int.random(in: 0...1)
            gameLogic.playSound(node: self,
                                audio: random == 0 ? Audio.EffectFiles.flameblinCatapult1 : Audio.EffectFiles.flameblinCatapult2, wait: false, muted: gameLogic.muted)
        case .gum:
            gameLogic.playSound(node: self,
                                audio: Audio.EffectFiles.gumblinCatapult1, wait: false, muted: gameLogic.muted)
        case .normal:
            gameLogic.playSound(node: self,
                                audio: Audio.EffectFiles.goblinCatapult1, wait: false, muted: gameLogic.muted)
        }
        
        if UserDefaults.standard.bool(forKey: "catapultTutorial") == false {
        gameLogic.tutorialEvent(index: 15, hud: hud, tutorialSheet: tutorialSheet)
            UserDefaults.standard.set(true, forKey: "catapultTutorial")
            hud.counter += 1
            hud.tutorialCounter.alpha = 1.0
            hud.tutorialCounter.text = String(hud.counter)
        }
        
        self.removeAllActions()
        self.hasRock = false
        let prof1 = Proficency(type: .catapult, level: 1)
        if let index = self.Proficiencies.firstIndex(where: { $0.id == prof1.id }) {
            self.Proficiencies.remove(at: index)
            self.addProficency(type: .catapult, level: 2)
        }
        else {
            let prof2 = Proficency(type: .catapult, level: 2)
            if let _ = self.Proficiencies.firstIndex(where: { $0.id == prof2.id }) {
            }
            else {
                self.addProficency(type: .catapult, level: 2)
            }
        }
        self.HWpoints += 75
        self.fitness = self.getFitness()
        if let structure = self.closeStructure as? Catapult {
            structure.hasRock = true
        }
        self.closeStructure = nil
    }
    
    private func throwSelf(_ hud: HUD, _ evilGauge: EvilGauge) {
        self.removeAllActions()
        gameLogic.removeAnimation(goblin: self)
        gameLogic.isFlyingAnimation(goblin: self)
        self.run(SKAction.move(to: CGPoint(x: gateCoordinates.x, y: gateCoordinates.y - 100), duration: 1.5), completion: {
            self.gameLogic.removeAnimation(goblin: self)
            if (self.type != .rock) {
                self.health -= 50
                if (self.gate != nil) {
                    self.gate!.health -= 3
                }
            }
            else {
                if (self.gate != nil) {
                    self.gate!.health -= 10
                }
            }
        })
        if let catapult = self.closeStructure as? Catapult {
            catapult.launchedGoblin = true
        }
        if (self.type != .rock) {
            self.HWpoints += 50
            
            switch self.type {
            case .normal:
                gameLogic.playSound(node: self,
                                    audio: Audio.EffectFiles.goblinSelfCatapult1, wait: false, muted: gameLogic.muted)
            case .fire:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self,
                                    audio: random == 0 ? Audio.EffectFiles.flameblinSelfCatapult1 : Audio.EffectFiles.flameblinSelfCatapult2, wait: false, muted: gameLogic.muted)
            case .gum:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self,
                                    audio: random == 0 ? Audio.EffectFiles.gumblinSelfCatapult1 : Audio.EffectFiles.gumblinSelfCatapult2, wait: false, muted: gameLogic.muted)
            case .rock:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self, audio: random == 0 ? Audio.EffectFiles.stoneblinSelfCatapult1 : Audio.EffectFiles.stoneblinSelfCatapult2, wait: false, muted: gameLogic.muted)
            }
            
            if UserDefaults.standard.bool(forKey: "catapultTutorial") == false {
            gameLogic.tutorialEvent(index: 15, hud: hud, tutorialSheet: tutorialSheet)
                UserDefaults.standard.set(true, forKey: "catapultTutorial")
                hud.counter += 1
                hud.tutorialCounter.alpha = 1.0
                hud.tutorialCounter.text = String(hud.counter)
            }
            
        }
        else {
            self.HWpoints += 100
            let random = Int.random(in: 0...1)
            gameLogic.playSound(node: self,
                                audio: random == 0 ? Audio.EffectFiles.stoneblinFly1 : Audio.EffectFiles.stoneblinFly1, wait: false, muted: gameLogic.muted)
        }
        let prof2 = Proficency(type: .catapult, level: 2)
        if let _ = self.Proficiencies.firstIndex(where: { $0.id == prof2.id }) {
        }
        else {
            let prof1 = Proficency(type: .catapult, level: 1)
            if let _ = self.Proficiencies.firstIndex(where: { $0.id == prof1.id }) {
            }
            else {
                self.addProficency(type: .catapult, level: 1)
            }
        }
        self.fitness = self.getFitness()
        self.closeStructure = nil
    }
    
    private func pickUpRock(_ hud: HUD, _ evilGauge: EvilGauge) {
        
        switch self.type {
        case .normal:
            gameLogic.playSound(node: self, audio: Audio.EffectFiles.goblinStone1, wait: false, muted: gameLogic.muted)
        case .fire:
            gameLogic.playSound(node: self, audio: Audio.EffectFiles.flameblinStone1, wait: false, muted: gameLogic.muted)
        case .rock:
            break
        case .gum:
            gameLogic.playSound(node: self, audio: Audio.EffectFiles.gumblinStone1, wait: false, muted: gameLogic.muted)
        }
        
        if UserDefaults.standard.bool(forKey: "rockTutorial") == false {
        gameLogic.tutorialEvent(index: 11, hud: hud, tutorialSheet: tutorialSheet)
            UserDefaults.standard.set(true, forKey: "rockTutorial")
            hud.counter += 1
            hud.tutorialCounter.alpha = 1.0
            hud.tutorialCounter.text = String(hud.counter)
        }
        
        self.closeStructure!.removeFromParent()
        self.HWpoints += 50
        self.hasRock = true
        self.fitness = self.getFitness()
        self.closeStructure = nil
    }
    
    private func eatRock(_ hud: HUD, _ evilGauge: EvilGauge) {
        let random = Int.random(in: 0...1)
        gameLogic.playSound(node: self,
                            audio: random == 0 ? Audio.EffectFiles.stoneblinTransform1 : Audio.EffectFiles.stoneblinTransform2, wait: false, muted: gameLogic.muted)
        gameLogic.playSound(node: self, audio: Audio.EffectFiles.rockEating, wait: false, muted: gameLogic.muted)
        
        if UserDefaults.standard.bool(forKey: "stoneblinTutorial") == false {
        gameLogic.tutorialEvent(index: 12, hud: hud, tutorialSheet: tutorialSheet)
            UserDefaults.standard.set(true, forKey: "stoneblinTutorial")
            hud.counter += 1
            hud.tutorialCounter.alpha = 1.0
            hud.tutorialCounter.text = String(hud.counter)
        }
        
        self.closeStructure!.removeFromParent()
        self.type = .rock
        self.texture = SKTexture(imageNamed: "rock_goblin")
        self.HWpoints += 150
        self.fitness = self.getFitness()
        self.closeStructure = nil
    }
    
    private func setFiretoTree(_ hud: HUD, _ evilGauge: EvilGauge) {
        setFireParticles()
        if UserDefaults.standard.bool(forKey: "treeTutorial") == false {
        gameLogic.tutorialEvent(index: 3, hud: hud, tutorialSheet: tutorialSheet)
            UserDefaults.standard.set(true, forKey: "treeTutorial")
            hud.counter += 1
            hud.tutorialCounter.alpha = 1.0
            hud.tutorialCounter.text = String(hud.counter)
        }
        
        switch self.type {
        case .normal:
            gameLogic.playSound(node: self, audio: Audio.EffectFiles.goblinBurn1, wait: false, muted: gameLogic.muted)
        case .fire:
            let random = Int.random(in: 0...1)
            gameLogic.playSound(node: self,
                                audio: random == 0 ? Audio.EffectFiles.flameblinBurn1 : Audio.EffectFiles.flameblinBurn2, wait: false, muted: gameLogic.muted)
        case .rock:
            gameLogic.playSound(node: self,
                                audio: Audio.EffectFiles.stoneblinBurn1, wait: false, muted: gameLogic.muted)
        case .gum:
            gameLogic.playSound(node: self, audio: Audio.EffectFiles.gumblinBurn1, wait: false, muted: gameLogic.muted)
        }
        gameLogic.playSound(node: self, audio: Audio.EffectFiles.treeOnFire, wait: false, muted: gameLogic.muted)
    
        self.closeStructure!.removeFromParent()
        evilGauge.updateGauge(goblin: nil, value: 1)
        self.HWpoints += 50
        self.fitness = self.getFitness()
        self.closeStructure = nil
    }
    
    private func setFiretoSelf(_ hud: HUD, _ evilGauge: EvilGauge) {
        setFireParticles()
        if UserDefaults.standard.bool(forKey: "fireTutorial") == false {
        gameLogic.tutorialEvent(index: 4, hud: hud, tutorialSheet: tutorialSheet)
            UserDefaults.standard.set(true, forKey: "fireTutorial")
            hud.counter += 1
            hud.tutorialCounter.alpha = 1.0
            hud.tutorialCounter.text = String(hud.counter)
        }
        
        gameLogic.playSound(node: self, audio: Audio.EffectFiles.flameblinTransform1, wait: false, muted: gameLogic.muted)
        gameLogic.playSound(node: self, audio: Audio.EffectFiles.treeOnFire, wait: false, muted: gameLogic.muted)
            
        self.closeStructure!.removeFromParent()
        self.type = .fire
        self.fear = 0
        self.maxFear = 0
        self.texture = SKTexture(imageNamed: "fire_goblin")
        let flameblinParticle = SKEmitterNode(fileNamed: "FlameblinParticle")
        flameblinParticle!.position = CGPoint(x: 0, y: 0)
        self.addChild(flameblinParticle!)
        flameblinParticle!.zPosition = -1
        self.HWpoints += 150
        self.fitness = self.getFitness()
        self.closeStructure = nil
    }
    
    private func addProficency(type: ProficencyType, level: Int) {
        let prof = Proficency(type: type, level: level)
        self.Proficiencies.append(prof)
    }
    
    private func setFireParticles() {
        let fireParticle = SKEmitterNode(fileNamed: "FireParticle")
        fireParticle!.name = "fireParticle"
        fireParticle!.position = closeStructure!.position
        fireParticle!.position.y -= 100
        fireParticle!.zPosition = -1
//        fireParticle!.particleColorSequence = nil
//        fireParticle!.particleColorBlendFactor = 1.0
//        fireParticle!.particleColor = UIColor(red: 125/255, green: 61/255, blue: 204/255, alpha: 1.0)
        fireParticle!.setScale(3)
        
        let smokeParticle = SKEmitterNode(fileNamed: "SmokeParticle")
        smokeParticle!.name = "smokeParticle"
        smokeParticle!.position = closeStructure!.position
        smokeParticle!.position.y -= 100
        smokeParticle!.zPosition = -1
        smokeParticle!.setScale(3)
        
        let addFireParticle = SKAction.run({
            self.parent!.scene!.addChild(fireParticle!)
        })
        let removeFireParticle = SKAction.run({
            fireParticle!.removeFromParent()
        })
        
        let addSmokeParticle = SKAction.run({
            self.parent!.scene!.addChild(smokeParticle!)
        })
        let removeSmokeParticle = SKAction.run({
            smokeParticle!.removeFromParent()
        })

        let fireFade = SKAction.run({
            fireParticle!.run(SKAction.fadeOut(withDuration: 0.7))
        })
        let smokeFade = SKAction.run({
            smokeParticle!.run(SKAction.fadeOut(withDuration: 2))
        })
        
        let burnSequence = SKAction.sequence([
            addSmokeParticle,
            addFireParticle,
            fireFade,
            smokeFade,
        ])
        
        self.parent!.run(burnSequence, withKey: "burnTreeParticle")
        
        let removeSequence = SKAction.sequence([
            .wait(forDuration: 3),
            removeFireParticle,
            removeSmokeParticle
        ])
        
        self.parent!.run(removeSequence, withKey: "removeParticle")
    }
    
    public func pressAnimation() -> Bool {
        var isDead = false
        let twoSecond = 120
        self.pressCounter += 1
        self.state = .inhand
        self.removeAllActions()
//        print("\(twoSecond - self.pressCounter)")
        if (twoSecond - self.pressCounter == 0 && isDead == false) {
            self.pressCounter = 0
            isDead = true
            switch self.type {
            case .rock:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self.parent?.scene?.camera, audio: random == 0 ? Audio.EffectFiles.stoneblinDeath2 : Audio.EffectFiles.stoneblinDeath3, wait: true, muted: gameLogic.muted)
            case .fire:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self.parent?.scene?.camera, audio: random == 0 ? Audio.EffectFiles.flameblinDeath2 : Audio.EffectFiles.flameblinDeath1, wait: true, muted: gameLogic.muted)
            case .gum:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self.parent?.scene?.camera, audio: random == 0 ? Audio.EffectFiles.gumblinDeath1 : Audio.EffectFiles.gumblinDeath2, wait: true, muted: gameLogic.muted)
            case .normal:
                let random = Int.random(in: 0...1)
                gameLogic.playSound(node: self.parent?.scene?.camera, audio: random == 0 ? Audio.EffectFiles.goblinDeath1 : Audio.EffectFiles.goblinDeath2, wait: true, muted: gameLogic.muted)
            }
            
            let goblinDeathParticle = SKEmitterNode(fileNamed: "GoblinDeathParticle")
            goblinDeathParticle!.position = self.position
            goblinDeathParticle!.name = "goblinDeathParticle"
            goblinDeathParticle!.zPosition = 1
            goblinDeathParticle!.particleColorSequence = nil
            goblinDeathParticle!.particleColorBlendFactor = 1.0
            
            switch self.type {
            case .rock:
                goblinDeathParticle!.particleColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0)
            case .fire:
                goblinDeathParticle!.particleColor = UIColor(red: 224/255, green: 53/255, blue: 50/255, alpha: 1.0)
            case .gum:
                goblinDeathParticle!.particleColor = UIColor(red: 255/255, green: 141/255, blue: 157/255, alpha: 1.0)
            case .normal:
                goblinDeathParticle!.particleColor = UIColor(red: 11/255, green: 129/255, blue: 80/255, alpha: 1.0)
            }
                                    
            let parent = self.parent!.scene!

            let addParticle = SKAction.run({
                parent.addChild(goblinDeathParticle!)
            })
            let goblinDeathFade = SKAction.run {
                goblinDeathParticle!.run(SKAction.fadeOut(withDuration: 0.4))
            }
            
            let particleSequence = SKAction.sequence([
                addParticle,
                goblinDeathFade
            ])

            let removeParticle = SKAction.run({
                goblinDeathParticle!.removeFromParent()
            })

            let removeSequence = SKAction.sequence([
                .wait(forDuration: 0.5),
                removeParticle
            ])

            parent.run(particleSequence)
            parent.run(removeSequence)
            
            self.removeFromParent()
            
            return isDead
        } else {
//            self.pressCounter = 0
            return false
        }
    }
 
    private func shouldFlip() {
        
        if (self.oldPosition != nil) {
            if Int((self.oldPosition?.x)!) > Int((self.position.x)) {
                self.xScale = -1
                
            } else if Int((self.oldPosition?.x)!) < Int((self.position.x)) {
                self.xScale = 1
            }
        }
        
        self.oldPosition = self.position
    }
}
