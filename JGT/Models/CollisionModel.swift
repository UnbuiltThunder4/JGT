//
//  CollisionModel.swift
//  JGT
//
//  Created by Eugenio Raja on 16/05/22.
//

import Foundation

struct Collision {
    enum Masks: Int {
        case goblin
        case map
        case enemy
        case building
        case enviroment
        var bitmask: UInt32 {return 1 << self.rawValue}
    }
    let masks: (first: UInt32, second: UInt32)
    
    func matches(_ first: Masks, _ second: Masks) -> Bool {
        return (first.bitmask == masks.first && second.bitmask == masks.second ||
                first.bitmask == masks.second && second.bitmask == masks.first)
    }
}
