//
//  Population.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import Foundation
import SwiftUI
import SpriteKit

class Population: ObservableObject {
    @Published public var goblins: [Goblin] = []
    public var size: Int
    public var mutationRate: Int
    
    private let reproductionTable = [
        (0, 20.0), (1, 15.0), (2, 10.0), (3, 8.0), (4, 7.0),
        (5, 6.0), (6, 5.0), (7, 4.0), (8, 3.0), (9, 2.0),
        (10, 1.0), (11, 1.0), (12, 1.0), (13, 1.0), (14, 1.0),
        (15, 1.0), (16, 1.0), (17, 1.0), (18, 1.0), (19, 1.0),
        (20, 1.0), (21, 1.0), (22, 1.0), (23, 1.0), (24, 1.0)]
    
    init(size: Int, mutationRate: Int) {
        self.size = size
        self.mutationRate = mutationRate
        self.generate(size)
    }
    
    public func getIndex(of: Goblin) -> Int? {
        return self.goblins.firstIndex(where: { $0.id == of.id })
    }
    
    public func update() {
        var hasToUpdateRank = false
        
        self.goblins.forEach {
            if ($0.update()) {
                hasToUpdateRank = true
            }
            if ($0.health <= 0) {
                self.kill($0)
            }
        }
        if (hasToUpdateRank) {
            self.rankPerFitness()
        }
    }
    
    public func generate(_ number: Int) -> [Goblin] {
        if (number > 0) {
            var newGoblins: [Goblin] = []
            for _ in 0..<number {
                if (self.goblins.count <= 10) {
                    let goblin = Goblin()
                    newGoblins.append(goblin)
                    goblin.fitness = goblin.getFitness()
                }
                else {
                    let goblin = self.crossbreed()
                    newGoblins.append(goblin)
                    goblin.fitness = goblin.getFitness()
                }
            }
            self.goblins.append(contentsOf: newGoblins)
            self.rankPerFitness()
            return newGoblins
        }
        else {
            return []
        }
    }
    
    public func kill(_ goblin: Goblin) {
        let index = self.goblins.firstIndex(of: goblin)!
        
        self.goblins[index].removeFromParent()
        self.goblins.remove(at: index)
        
    }
    
    public func rankPerFitness() {
        var swap = true
        while swap == true {
            swap = false
            for i in 0..<self.goblins.count - 1 {
                if self.goblins[i].fitness < self.goblins[i + 1].fitness {
                    let temp = self.goblins[i + 1]
                    self.goblins[i + 1] = self.goblins[i]
                    self.goblins[i] = temp
                    
                    swap = true
                }
            }
        }
    }
    
    public func rankPerFitness(goblin: Goblin) {
        let index = self.getIndex(of: goblin)
        if (index != nil) {
            var swap = true
            while swap == true {
                swap = false
                if (self.goblins[index!].fitness > self.goblins[index! - 1].fitness) {
                    let temp = self.goblins[index!]
                    self.goblins[index!] = self.goblins[index! - 1]
                    self.goblins[index! - 1] = temp
                    swap = true
                }
            }
        }
    }
    
    private func crossbreed() -> Goblin {
        
        var parents: [Goblin] = []
        
        for _ in (0..<2) {
            var index = weightedRandom(weightedValues: self.reproductionTable)
            while (index >= self.goblins.count) {
                index = weightedRandom(weightedValues: self.reproductionTable)
            }
            parents.append(self.goblins[index])
        }
        
        let index = getParentIndex()
        
        let name1 = self.goblins.randomElement()!.fullName
        var name2 = self.goblins.randomElement()!.fullName
        while (name2 == name1) {
            name2 = self.goblins.randomElement()!.fullName
        }
        
        let goblin = Goblin(
            health: parents[index[0]].maxHealth + Int.random(in: -4...4),
            attack: parents[index[1]].attack + Int.random(in: -2...2),
            wit: parents[0].wit.merge(other: parents[1].wit),
            fear: parents[index[2]].maxFear + Int.random(in: -3...3),
            frenzy: parents[index[3]].frenzy + Int.random(in: -1...1),
            randomGoblin1: name1,
            randomGoblin2: name2
        )
        
        goblin.mutate(goblin: goblin, mutationRate: self.mutationRate)
        goblin.checkStatsCap(goblin)
        
        return goblin
    }
}

