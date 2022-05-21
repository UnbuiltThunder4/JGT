
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
    
    public let fullName: String
    public let backstory: String
    public var type: GoblinType
    public var age: Int = 0
    private var agecounter: Int = 0
    
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
    public var hasRock: Bool = false
    
    public var target: Enemy? = nil
    public var targetQueue: [Enemy] = []
    
    private var destination: CGPoint
    private var inVillageCounter: Int = 0
    private var inAcademyCounter: Int = 0
    private var inTavernCounter: Int = 0
    private var frenzyCounter: Int = 0
    
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
            goblin.maxHealth = Int.random(in: 10..<101)
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
    
    public func update() -> Bool {
        var hasToUpdateRank = false
        switch self.state {
            
        case .idle:
            hasToUpdateRank = idleUpdate()
            break
            
        case .fighting:
            fightingUpdate()
            break
            
        case .feared:
            fearedUpdate()
            break
            
        case .intavern:
            inTavernUpdate()
            break
            
        case .inacademy:
            hasToUpdateRank = inAcademyUpdate()
            break
            
        case .invillage:
            hasToUpdateRank = inVillageUpdate()
            break
            
        case .inhand:
            inHandUpdate()
            break
            
        case .flying:
            flyingUpdate()
            break
            
        case .launched:
            launchedUpdate()
            break
            
        default:
            hasToUpdateRank = idleUpdate()
            break
        }
        return hasToUpdateRank
    }
    
    private func idleUpdate() -> Bool {
        var hasToUpdateRank = false
        self.updateAge()
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
                        if (self.closeStructure != nil && self.isFrenzied == false) {
                            let targetDistance = CGVector(dx: self.closeStructure!.position.x - self.position.x, dy: self.closeStructure!.position.y - self.position.y)
                            if (abs(targetDistance.dx) < 200 && abs(targetDistance.dy) < 200) {
                                if (self.closeStructure!.type != .tavern || !(self.isGraduated && self.closeStructure!.type == .academy)) {
                                    let prediction = self.wit.predict(
                                        input: .init(size: .init(width: 2),
                                                     body: [Float(self.type.rawValue), Float(self.closeStructure!.type.rawValue)]))
                                    var output: Int = 0
                                    if (prediction[0] >= prediction[1]) {
                                        if (prediction[0] > 0.4) {
                                            output = 1
                                        }
                                    }
                                    else {
                                        if (prediction[1] > 0.5) {
                                            output = 2
                                        }
                                    }
                                    if(output > 0) {
                                        print("action \(output): value \(prediction[output-1])")
                                        hasToUpdateRank = self.checkInterations(input: output)
                                    }
                                    else {
                                        print("ignored")
                                    }
                                    self.closeStructure = nil
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
                                y: Double.random(in: 60...MainScreenProperties.bgheight - 60))
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
            }
        }
        else {
            self.state = .feared
            removeAction(forKey: "walk")
        }
        return hasToUpdateRank
    }
    
    private func fightingUpdate() {
        self.updateAge()
        if (self.isFrenzied) {
            self.checkFrenzy()
        }
        if (!self.checkFear()) {
            if (self.target != nil) {
                let targetDistance = CGVector(dx: self.target!.position.x - self.position.x, dy: self.target!.position.y - self.position.y)
                let walkDistance = limitVector(vector: targetDistance, max: 20)
                if let _ = self.action(forKey: "walk") {
                    if (abs(targetDistance.dx) < 60 && abs(targetDistance.dy) < 60) {
                        var dmg = self.attack
                        if (self.isFrenzied) {
                            dmg += self.attack
                        }
                        self.target!.health -= dmg //DAMAGE ONLY AT THE END OF ANIMATION
                        if (self.type == .fire) {
                            self.targetQueue.forEach {
                                let aoeDistance = CGVector(dx: $0.position.x - self.position.x, dy: $0.position.y - self.position.y)
                                if (abs(aoeDistance.dx) < 60 && abs(aoeDistance.dy) < 60) {
                                    $0.health -= dmg
                                    if ($0.health <= 0) {
                                        let index = self.targetQueue.firstIndex(of: $0)!
                                        self.targetQueue.remove(at: index)
                                    }
                                }
                            }
                        }
                        if (self.target!.health <= 0) {
                            self.target = nil
                            self.state = .idle
                            removeAction(forKey: "walk")
                        }
                    }
                }
                else {
                    let time = getDuration(distance: walkDistance, speed: self.speed)
                    let walk = SKAction.move(by: walkDistance, duration: time)
                    self.run(walk, withKey: "walk")
                }
            }
            else {
                self.state = .idle
                removeAction(forKey: "walk")
            }
        }
        else {
            self.state = .feared
            self.target = nil
            self.targetQueue = []
            removeAction(forKey: "walk")
        }
    }
    
    private func fearedUpdate() {
        self.updateAge()
        if let _ = self.action(forKey: "run") {
        }
        else {
            let tavernDistance = CGVector(dx: tavernCoordinates.x - self.position.x, dy: tavernCoordinates.y - self.position.y)
            if (abs(tavernDistance.dx) < 250 && abs(tavernDistance.dy) < 250) {
                self.enterTavern()
            }
            else {
                var distance = limitVector(vector: tavernDistance, max: 100)
                distance.dx = distance.dx * CGFloat.random(in: 0.2...1.8)
                distance.dy = distance.dy * CGFloat.random(in: 0.2...1.8)
                let time = getDuration(distance: distance, speed: self.speed * 2)
                let run = SKAction.move(by: distance, duration: time)
                self.run(run, withKey: "run")
            }
        }
    }
    
    private func inHandUpdate() {
        self.removeAllActions()
    }
    
    private func inTavernUpdate() {
        self.updateAge()
        self.removeAllActions()
        self.inTavernCounter += 1
        if (self.inTavernCounter % 120 == 0) {
            self.currentFrenzyTurn += 1
            self.inTavernCounter = 0
            if (self.health + 10 <= self.maxHealth) {
                self.health += 10
            }
            else {
                self.health = self.maxHealth
            }
            if (self.currentFrenzyTurn >= self.frenzy) {
                self.isFrenzied = true
                self.fear = 0
                self.state = .idle
                self.alpha = 1.0
            }
        }
    }
    
    private func inAcademyUpdate() -> Bool {
        var hasToUpdateRank = false
        self.updateAge()
        self.removeAllActions()
        self.inAcademyCounter += 1
        if (self.inAcademyCounter % 360 == 0) {
            self.inAcademyCounter = 0
            self.isGraduated = true
            self.state = .idle
            self.alpha = 1.0
            self.HWpoints += 10
            self.fitness = self.getFitness()
            hasToUpdateRank = true
        }
        return hasToUpdateRank
    }
    
    private func inVillageUpdate() -> Bool {
        var hasToUpdateRank = false
        self.updateAge()
        self.removeAllActions()
        self.inVillageCounter += 1
        if (self.inVillageCounter % 60 == 0) {
            //GIVE EVIL POINTS
            self.inVillageCounter = 0
            let randnum = Int.random(in: 0...100)
            if (randnum <= 5 && self.type == .normal) {
                self.state = .idle
                self.alpha = 1.0
                self.type = .gum
                self.texture = SKTexture(imageNamed: "gum_goblin")
                self.HWpoints += 15
                self.fitness = self.getFitness()
                hasToUpdateRank = true
            }
            else if (randnum <= 30) {
                self.state = .idle
                self.alpha = 1.0
            }
        }
        return hasToUpdateRank
    }
    
    private func flyingUpdate() {
        self.updateAge()
        if (self.physicsBody!.velocity.dx != 0 || self.physicsBody!.velocity.dy != 0) {
            gameLogic.friction(node: self)
        }
        else {
            self.state = .idle
        }
    }
    
    private func launchedUpdate() {
        self.updateAge()
        if let _ = self.action(forKey: "launched") {
        }
        else {
            self.state = .idle
        }
    }
    
    private func updateAge() {
        self.agecounter += 1
        if (self.agecounter % 300 == 0) {
            self.age += 1
            self.agecounter = 0
        }
    }
    
    private func checkFear() -> Bool {
        let percentage = (Double(self.health) / Double(self.maxHealth)) * 100.0
        if (percentage <= Double(self.fear)) {
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
        }
        else {
            self.frenzyCounter += 1
            if (self.frenzyCounter % 60 == 0) {
                self.currentFrenzyTurn -= 1
                self.frenzyCounter = 0
            }
        }
    }
    
    private func checkInterations(input: Int) -> Bool {
        var hasToUpdateRank = false
        switch self.closeStructure!.type {
            
        case .academy:
            if (input == 2) {
                self.enterAcademy()
            }
            break
            
        case .village:
            if (input == 2 && self.type != .gum) {
                self.enterVillage()
            }
            break
            
        case .rock:
            if (input == 1) {
                if (!self.hasRock) {
                    self.pickUpRock()
                }
            }
            else if (input == 2) {
                if (self.type == .normal) {
                    self.eatRock()
                }
                else {
                    if (!self.hasRock) {
                        self.pickUpRock()
                    }
                }
            }
            hasToUpdateRank = true
            break
            
        case .tree:
            if (input == 1) {
                self.setFiretoTree()
            }
            else if (input == 2) {
                if (self.type == .normal) {
                    self.setFiretoSelf()
                }
                else {
                    self.setFiretoTree()
                }
            }
            hasToUpdateRank = true
            break
            
        default:
            break
            
        }
        return hasToUpdateRank
    }
    
    private func enterAcademy() {
        self.state = .inacademy
        self.alpha = 0.0
    }
    
    private func enterTavern() {
        self.state = .intavern
        self.alpha = 0.0
    }
    
    private func enterVillage() {
        self.state = .invillage
        self.alpha = 0.0
    }
    
    private func pickUpRock() {
        self.closeStructure!.removeFromParent()
        self.HWpoints += 5
        self.hasRock = true
        self.fitness = self.getFitness()
    }
    
    private func eatRock() {
        self.closeStructure!.removeFromParent()
        self.type = .rock
        self.texture = SKTexture(imageNamed: "rock_goblin")
        self.HWpoints += 15
        self.fitness = self.getFitness()
    }
    
    private func setFiretoTree() {
        self.closeStructure!.removeFromParent()
        self.HWpoints += 5
        self.fitness = self.getFitness()
    }
    
    private func setFiretoSelf() {
        self.closeStructure!.removeFromParent()
        self.type = .fire
        self.fear = 0
        self.maxFear = 0
        self.texture = SKTexture(imageNamed: "fire_goblin")
        self.HWpoints += 15
        self.fitness = self.getFitness()
    }
    
}
