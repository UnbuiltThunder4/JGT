//
//  ProficencyModel.swift
//  JGT
//
//  Created by Eugenio Raja on 09/05/22.
//

import Foundation
import SwiftUI

struct Proficency {
    public let type: ProficencyType
    public var level: Int
    
    init(type: ProficencyType, level: Int) {
        self.type = type
        self.level = level
    }
}
