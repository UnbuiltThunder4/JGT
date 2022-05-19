//
//  TestView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import SwiftUI

struct TestView: View {
    
    @ObservedObject var population = Population(size: 8, mutationRate: 10)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach (population.goblins) { (goblin: Goblin) in
                    TestGoblinView(population: population, goblin: goblin)
                }
            }
            Button("Generate") {
                self.population.generate(1)
            }
            .padding(8)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(10)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
