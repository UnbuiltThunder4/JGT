//
//  TestGoblinView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import Foundation
import SwiftUI

struct TestGoblinView: View {
    
    @ObservedObject var population: Population
    @ObservedObject var goblin: Goblin
    
    init(population: Population, goblin: Goblin) {
        self.population = population
        self.goblin = goblin
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(goblin.fullName)")
                .padding(2)
                .foregroundColor(.red)
            Text("\(goblin.backstory)")
                .padding(2)
            Text("Health: \(goblin.maxHealth)")
                .padding(2)
            Text("Attack: \(goblin.attack)")
                .padding(2)
            Text("Wit:\n\(goblin.wit.summary())")
                .padding(2)
            Text("Fear: \(goblin.maxFear)")
                .padding(2)
            Text("Frenzy: \(goblin.frenzy)")
                .padding(2)
            Text("Fitness: \(goblin.fitness)")
                .padding(2)
                .foregroundColor(.blue)
            Button("Kill") {
                population.kill(goblin)
            }
            .padding(8)
            .foregroundColor(.white)
            .background(.red)
            .cornerRadius(10)
        }
    }
}
