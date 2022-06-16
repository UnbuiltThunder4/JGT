//
//  Constants.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import Foundation
import SwiftUI

enum GaugeHUDSetting {
    static let ipadSize = CGSize(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/1.2)
    static let iphoneSize = CGSize(width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.height/1.2)
}

enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad   // iPad style UI (also includes macOS Catalyst)
}

enum ZoomProperties {
    static var initialScale = 1.0
    static var minimumZoom = 0.8
    static var maximumZoom = 2.0
    static var cameraOffsetx = 30.0
    static var cameraOffsety = 30.0
    static var initialOffsetx = 230.0
    static var initialOffsety = 120.0
}

enum GameState {
    case mainScreen
    case playing
    case selection
    case gameOver
}

typealias Instruction = (icon: String, title: String, description: String)

let levelNames: [String] = [
    "The First Assault",
    "The Siege Weapons",
    "The Shocking Stand"
]

struct MainScreenProperties {
    static let gameTitle: String = "Throw Da Goblin"
        
    static let gameInstructions: [Instruction] = [
        (icon: "hand.raised", title: "Instruction 1", description: "Instruction description."),
        (icon: "hand.tap", title: "Instruction 2", description: "Instruction description."),
        (icon: "hand.draw", title: "Instruction 3", description: "Instruction description."),
        (icon: "hand.tap", title: "Instruction 4", description: "Instruction description."),
        (icon: "hand.raised", title: "Instruction 5", description: "Instruction description."),
        (icon: "hands.sparkles", title: "Instruction 6", description: "Instruction description."),
    ]
    
    /**
     * To change the Accent Color of the applciation edit it on the Assets folder.
     */
    
    static let accentColor: Color = Color.accentColor
    
    static let maxAspectRatio: CGFloat = 16.0/9.0
    static let playableHeight = UIScreen.main.bounds.width / maxAspectRatio
    static let playableMargin = (UIScreen.main.bounds.height - playableHeight) / 2.0
    
    static let bg = UIImage(named: "forest")
    static let bgwidth = bg!.size.width
    static let bgheight = bg!.size.height
    
    static let maxFill = 20
    static let maxGoblinsNumber = 50 
}

let oneSecond = 60
let threeSeconds = 180
let fiveSeconds = 300
let tenSeconds = 600
let twentySeconds = 1200
let taskTime = 120
let attackTime = 120
let ageTime = 300
let structureTime = 360

let player = AudioPlayerImpl()

public enum GoblinState {
    case working
    case fighting
    case feared
    case idle
    case flying
    case launched
    case inhand
    case intavern
    case inacademy
    case invillage
    case intrap
    case backdooring
    case gating
    case passaging
    case stunned
    case paused
}

public enum GoblinType: Int {
    case rock = 0
    case fire = 1
    case gum = 2
    case normal = 3
}

public enum EnemyState {
    case fighting
    case idle
    case paused
}

public enum EnemyType: Int {
    case small = 0
    case bow = 1
    case axe = 2
}

let gnomes1: [Enemy] = [
    Enemy(type: .small, x: 700, y: 2200),
    Enemy(type: .small, x: 1000, y: 2000), //academy gnomes
    Enemy(type: .small, x: 700, y: 1800),
    Enemy(type: .small, x: 1500, y: 1900),
    
    Enemy(type: .small, x: 1550, y: 1250), //left center gnome
    
    Enemy(type: .small, x: 2550, y: 600), // bottom right gnome

    Enemy(type: .small, x: 800, y: 1200), // bottom left gnome
    
    Enemy(type: .small, x: 1800, y: 2600), // upper right center gnomes
    Enemy(type: .small, x: 2000, y: 2400),
        
    Enemy(type: .small, x: 2700, y: 2500),
    Enemy(type: .small, x: 2900, y: 2500), //team rocket gnomes
    
    Enemy(type: .small, x: 2700, y: 3250), //backdoor gnomes
    Enemy(type: .small, x: 2900, y: 3250),
    Enemy(type: .small, x: 2800, y: 3150),
    
//    Enemy(type: .bow, x: 2800, y: 2400), //backdoor gnome
    
    Enemy(type: .small, x: 750, y: 3050), //upper left gnome
    
    Enemy(type: .bow, x: 1672, y: 4200), //on gate gnomes
//    Enemy(type: .bow, x: 1470, y: 4200),


    Enemy(type: .axe, x: 1250, y: 2350), //near academy gnomes
    
    Enemy(type: .axe, x: 1600, y: 3450), //gate gnomes
    Enemy(type: .axe, x: 1800, y: 3450),
    Enemy(type: .axe, x: 1700, y: 3250)
]

let gnomes2: [Enemy] = [
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .small, x: 800, y: 2300),
    
    Enemy(type: .bow, x: 2600, y: 4200), //gate
    Enemy(type: .bow, x: 2800, y: 4200),
    
    Enemy(type: .axe, x: 2650, y: 3600), //gate
    Enemy(type: .axe, x: 2750, y: 3500),
    Enemy(type: .axe, x: 2850, y: 3600),
    Enemy(type: .small, x: 2650, y: 3300),
    Enemy(type: .small, x: 2750, y: 3300),
    Enemy(type: .small, x: 2850, y: 3300),
    
    Enemy(type: .axe, x: 400, y: 3600), //backdoor
    Enemy(type: .axe, x: 600, y: 3600),
    Enemy(type: .axe, x: 500, y: 3300),
    
    Enemy(type: .small, x: 1600, y: 3600), //catapult
    Enemy(type: .small, x: 1800, y: 3600),
    Enemy(type: .axe, x: 1500, y: 3600),
    Enemy(type: .axe, x: 1900, y: 3600),
    Enemy(type: .axe, x: 1550, y: 3300),
    Enemy(type: .axe, x: 1850, y: 3300),
    Enemy(type: .small, x: 1600, y: 3100),
    Enemy(type: .small, x: 1800, y: 3100),
    
    Enemy(type: .axe, x: 2500, y: 1450),
    Enemy(type: .axe, x: 1350, y: 2800),
    Enemy(type: .axe, x: 2500, y: 1450),
    Enemy(type: .axe, x: 1350, y: 2800),
    Enemy(type: .axe, x: 2500, y: 1450),
    Enemy(type: .axe, x: 1350, y: 2800),
    Enemy(type: .axe, x: 2500, y: 1450)
]

let gnomes3: [Enemy] = [
    Enemy(type: .small, x: 800, y: 2300),
    Enemy(type: .small, x: 1200, y: 2300),
    Enemy(type: .axe, x: 1350, y: 2800),
    Enemy(type: .axe, x: 2500, y: 1450)
]

public enum ProficencyType {
    case catapult
    case trap
    case backdoor
}

public enum StructureType: Int {
    case tree = 0
    case rock = 1
    case catapult = 2
    case backdoor = 3
    case academy = 4
    case village = 5
    case tavern = 6
    case trap = 7
    case gate = 8
    case passage = 9
    case goblincircle = 10
    case wall = 11
}

let goblinmancyCircleCoordinates1 = CGPoint(x: 1672, y: 350)
let academyCoordinates1 = CGPoint(x: 2900, y: 1400)
let tavernCoordinates1 = CGPoint(x: 700, y: 2000)
let villageCoordinates1 = CGPoint(x: 1000, y: 2500)
let catapultCoordinates1 = CGPoint(x: 1350, y: 3000)
let gateCoordinates1 = CGPoint(x: 1672, y: 3750)
let backdoorCoordinates1 = CGPoint(x: 2800, y: 3635)
let passageCoordinates1 = CGPoint(x: 2800, y: 4100)

let goblinmancyCircleCoordinates2 = CGPoint(x: 350, y: 240)
let tavernCoordinates2 = CGPoint(x: 1572, y: 950)
let academyCoordinates2 = CGPoint(x: 2900, y: 1250)
let villageCoordinates2 = CGPoint(x: 1000, y: 2500)
let catapultCoordinates2 = CGPoint(x: 1680, y: 3400)
let gateCoordinates2 = CGPoint(x: 2700, y: 3750)
let backdoorCoordinates2 = CGPoint(x: 500, y: 3635)
let passageCoordinates2 = CGPoint(x: 500, y: 4100)

let goblinmancyCircleCoordinates3 = CGPoint(x: 1600, y: 550)
let tavernCoordinates3 = CGPoint(x: 1100, y: 950)
let academyCoordinates3 = CGPoint(x: 2650, y: 1550)
let villageCoordinates3 = CGPoint(x: 1000, y: 2500)
let catapultCoordinates3 = CGPoint(x: 1350, y: 3000)
let gateCoordinates3 = CGPoint(x: 1600, y: 3750)
let backdoorCoordinates3 = CGPoint(x: 500, y: 3635)
let passageCoordinates3 = CGPoint(x: 500, y: 4100)

var goblinmancyCircleCoordinates = CGPoint()
var tavernCoordinates = CGPoint()
var academyCoordinates = CGPoint()
var villageCoordinates = CGPoint()
var catapultCoordinates = CGPoint()
var gateCoordinates = CGPoint()
var backdoorCoordinates = CGPoint()
var passageCoordinates = CGPoint()

let levelstructures1: [Structure] = [
    Structure(type: .wall, x: 1680, y: 3900, rotation: 0),
    
    Gate(x: gateCoordinates.x, y: gateCoordinates.y), // THIS HAS TO BE ON INDEX 1
    
    Backdoor(x: backdoorCoordinates.x, y: backdoorCoordinates.y),  // THIS HAS TO BE ON INDEX 2
    
//    Catapult(x: catapultCoordinates.x, y: catapultCoordinates.y), // THIS HAS TO BE ON INDEX 3
    
//    Trap(x: catapultCoordinates.x + 1000, y: catapultCoordinates.y),  // THIS HAS TO BE ON INDEX 4
    
    Tavern(x: tavernCoordinates.x, y: tavernCoordinates.y),
    
    Academy(x: academyCoordinates.x, y: academyCoordinates.y),
    
//    Village(x: villageCoordinates.x, y: villageCoordinates.y),
    
    Structure(type: .passage, x: passageCoordinates.x, y: passageCoordinates.y, rotation: 0),
    
    Structure(type: .goblincircle, x: goblinmancyCircleCoordinates.x, y: goblinmancyCircleCoordinates.y, rotation: 0),
    
    Structure(type: .tree, x: 450, y: 1200, rotation: 0),
    Structure(type: .tree, x: 620, y: 1050, rotation: 0),
    Structure(type: .tree, x: 390, y: 1000, rotation: 0),
    Structure(type: .tree, x: 600, y: 830, rotation: 0),
    Structure(type: .tree, x: 800, y: 790, rotation: 0), //bottom left trees
    Structure(type: .tree, x: 400, y: 750, rotation: 0),
    
    Structure(type: .tree, x: 2800, y: 500, rotation: 0),
    Structure(type: .tree, x: 2700, y: 400, rotation: 0),
    Structure(type: .tree, x: 2460, y: 400, rotation: 0),
    Structure(type: .tree, x: 2950, y: 270, rotation: 0), //bottom right trees
    Structure(type: .tree, x: 2800, y: 250, rotation: 0),
    Structure(type: .tree, x: 2620, y: 230, rotation: 0),

    Structure(type: .tree, x: 1250, y: 1350, rotation: 0),
    Structure(type: .tree, x: 1100, y: 1250, rotation: 0), //left center trees
    Structure(type: .tree, x: 1350, y: 1250, rotation: 0),

    Structure(type: .tree, x: 2050, y: 1450, rotation: 0),
    Structure(type: .tree, x: 2250, y: 1420, rotation: 0),
    Structure(type: .tree, x: 2050, y: 1250, rotation: 0), //right center trees
    Structure(type: .tree, x: 2350, y: 1260, rotation: 0),
    Structure(type: .tree, x: 2200, y: 1050, rotation: 0),
    
    Structure(type: .tree, x: 2500, y: 1850, rotation: 0),
    Structure(type: .tree, x: 2900, y: 1950, rotation: 0), //tavern trees
    Structure(type: .tree, x: 3100, y: 1900, rotation: 0),
    
    Structure(type: .tree, x: 2250, y: 2050, rotation: 0),
    Structure(type: .tree, x: 2100, y: 1950, rotation: 0), //center trees
    Structure(type: .tree, x: 2350, y: 1950, rotation: 0),
        
    Structure(type: .tree, x: 450, y: 3400, rotation: 0),
    Structure(type: .tree, x: 620, y: 3250, rotation: 0),
    Structure(type: .tree, x: 390, y: 3200, rotation: 0),
    Structure(type: .tree, x: 600, y: 3030, rotation: 0),
//    Structure(type: .tree, x: 800, y: 2990, rotation: 0), //center upper left trees
    Structure(type: .tree, x: 400, y: 2950, rotation: 0),
    
    Structure(type: .tree, x: 2800, y: 3550, rotation: 0),
    Structure(type: .tree, x: 2600, y: 3450, rotation: 0),
    Structure(type: .tree, x: 2700, y: 3450, rotation: 0), //backdoor trees
    Structure(type: .tree, x: 2950, y: 3450, rotation: 0),
    Structure(type: .tree, x: 3050, y: 3450, rotation: 0),
    Structure(type: .tree, x: 2500, y: 3350, rotation: 0),
    Structure(type: .tree, x: 3150, y: 3350, rotation: 0),
    Structure(type: .tree, x: 2400, y: 3250, rotation: 0),
    Structure(type: .tree, x: 3250, y: 3250, rotation: 0),
    Structure(type: .tree, x: 2500, y: 3150, rotation: 0),
    Structure(type: .tree, x: 3150, y: 3150, rotation: 0),
    Structure(type: .tree, x: 2600, y: 3050, rotation: 0),
    Structure(type: .tree, x: 2700, y: 3050, rotation: 0), //backdoor trees
    Structure(type: .tree, x: 2950, y: 3050, rotation: 0),
    Structure(type: .tree, x: 3050, y: 3050, rotation: 0),
    Structure(type: .tree, x: 2950, y: 2950, rotation: 0),
    Structure(type: .tree, x: 2700, y: 2950, rotation: 0),
    Structure(type: .tree, x: 2800, y: 2850, rotation: 0),
]

let levelstructures2: [Structure] = [
    Structure(type: .wall, x: 1680, y: 3900, rotation: 0),
    Gate(x: gateCoordinates2.x, y: gateCoordinates2.y), // THIS HAS TO BE ON INDEX 1
    Backdoor(x: backdoorCoordinates2.x, y: backdoorCoordinates2.y),  // THIS HAS TO BE ON INDEX 2
    Catapult(x: catapultCoordinates2.x, y: catapultCoordinates2.y), // THIS HAS TO BE ON INDEX 3
    Tavern(x: tavernCoordinates2.x, y: tavernCoordinates2.y),
    Academy(x: academyCoordinates2.x, y: academyCoordinates2.y),
    Structure(type: .passage, x: passageCoordinates2.x, y: passageCoordinates2.y, rotation: 0),
    Structure(type: .goblincircle, x: goblinmancyCircleCoordinates2.x, y: goblinmancyCircleCoordinates2.y, rotation: 0),
    
    Structure(type: .rock, x: 1450, y: 500, rotation: 0), //low center
    Structure(type: .rock, x: 1910, y: 500, rotation: 0),
    Structure(type: .rock, x: 1350, y: 130, rotation: 0),
    Structure(type: .rock, x: 1960, y: 130, rotation: 0),
    Structure(type: .tree, x: 1670, y: 500, rotation: 0),
    Structure(type: .tree, x: 1500, y: 350, rotation: 0),
    Structure(type: .tree, x: 1700, y: 325, rotation: 0),
    Structure(type: .tree, x: 1900, y: 340, rotation: 0),
    
    Structure(type: .rock, x: 100, y: 1110, rotation: 0), //left above circle
    Structure(type: .rock, x: 450, y: 1160, rotation: 0),
    Structure(type: .tree, x: 200, y: 1010, rotation: 0),
    Structure(type: .tree, x: 350, y: 1060, rotation: 0),
    
    Structure(type: .rock, x: 2370, y: 910, rotation: 0), //rock alone
    Structure(type: .tree, x: 2480, y: 1100, rotation: 0), // tree friend
    
    Structure(type: .rock, x: 2050, y: 1530, rotation: 0), //far apart group on right
    Structure(type: .rock, x: 2360, y: 1700, rotation: 0),
    Structure(type: .rock, x: 2800, y: 1850, rotation: 0),
    Structure(type: .rock, x: 2510, y: 2020, rotation: 0),
    Structure(type: .tree, x: 1930, y: 1610, rotation: 0),
    Structure(type: .tree, x: 2790, y: 1850, rotation: 0),
    Structure(type: .tree, x: 2940, y: 1800, rotation: 0),
    
    Structure(type: .rock, x: 360, y: 1800, rotation: 0), //left triangle
    Structure(type: .rock, x: 760, y: 1800, rotation: 0),
    Structure(type: .rock, x: 560, y: 2020, rotation: 0),
    Structure(type: .tree, x: 580, y: 1800, rotation: 0),
    
    Structure(type: .rock, x: 800, y: 2500, rotation: 0), //left 2 that do a \
    Structure(type: .rock, x: 600, y: 2700, rotation: 0),
    
    Structure(type: .rock, x: 1450, y: 2600, rotation: 0), //one on top of the other
    Structure(type: .rock, x: 1495, y: 2350, rotation: 0),
    Structure(type: .tree, x: 1380, y: 2400, rotation: 0),
    
    Structure(type: .rock, x: 2470, y: 2920, rotation: 0), //last ones of the top right
    Structure(type: .rock, x: 2750, y: 2500, rotation: 0),

    Structure(type: .rock, x: 1180, y: 3500, rotation: 0), //around the catapult
    Structure(type: .rock, x: 2180, y: 3500, rotation: 0),
    Structure(type: .rock, x: 1350, y: 3330, rotation: 0),
    Structure(type: .rock, x: 2010, y: 3330, rotation: 0),
    Structure(type: .rock, x: 1680, y: 3200, rotation: 0),
    Structure(type: .rock, x: 1250, y: 3130, rotation: 0),
    Structure(type: .rock, x: 2110, y: 3130, rotation: 0),
    Structure(type: .rock, x: 1680, y: 2900, rotation: 0),
    
    Structure(type: .tree, x: 2800, y: 3050, rotation: 0), //tree cross
    Structure(type: .tree, x: 2800, y: 2900, rotation: 0),
    Structure(type: .tree, x: 2800, y: 2750, rotation: 0),
    Structure(type: .tree, x: 2650, y: 2900, rotation: 0),
    Structure(type: .tree, x: 2950, y: 2900, rotation: 0),
         
    Structure(type: .tree, x: 700, y: 3550, rotation: 0), //trees near backdoor
    Structure(type: .tree, x: 750, y: 3400, rotation: 0),
    
    Structure(type: .tree, x: 650, y: 3250, rotation: 0),
    Structure(type: .tree, x: 600, y: 3100, rotation: 0),
   
    Structure(type: .tree, x: 775, y: 3250, rotation: 0),
    Structure(type: .tree, x: 725, y: 3100, rotation: 0),
    
    Structure(type: .tree, x: 150, y: 3100, rotation: 0),
    Structure(type: .tree, x: 300, y: 3100, rotation: 0),
    Structure(type: .tree, x: 450, y: 3100, rotation: 0),
    Structure(type: .tree, x: 100, y: 2900, rotation: 0),
    Structure(type: .tree, x: 250, y: 2900, rotation: 0),
    Structure(type: .tree, x: 400, y: 2900, rotation: 0),
    Structure(type: .tree, x: 100, y: 2700, rotation: 0),
    Structure(type: .tree, x: 250, y: 2700, rotation: 0),
    Structure(type: .tree, x: 400, y: 2700, rotation: 0),
    
    Structure(type: .tree, x: 550, y: 2950, rotation: 0)
]

let levelstructures3: [Structure] = [
    Structure(type: .wall, x: 1680, y: 3900, rotation: 0),
    Gate(x: gateCoordinates3.x, y: gateCoordinates3.y), // THIS HAS TO BE ON INDEX 1
    Backdoor(x: backdoorCoordinates3.x, y: backdoorCoordinates3.y),  // THIS HAS TO BE ON INDEX 2
    Catapult(x: catapultCoordinates3.x, y: catapultCoordinates3.y), // THIS HAS TO BE ON INDEX 3
    Trap(x: catapultCoordinates3.x + 1000, y: catapultCoordinates3.y),  // THIS HAS TO BE ON INDEX 4
    Tavern(x: tavernCoordinates3.x, y: tavernCoordinates3.y),
    Academy(x: academyCoordinates3.x, y: academyCoordinates3.y),
    Village(x: villageCoordinates3.x, y: villageCoordinates3.y),
    Structure(type: .passage, x: passageCoordinates2.x, y: passageCoordinates2.y, rotation: 0),
    Structure(type: .goblincircle, x: goblinmancyCircleCoordinates2.x, y: goblinmancyCircleCoordinates2.y, rotation: 0),
    Structure(type: .tree, x: 350, y: 1350, rotation: 0),
    Structure(type: .tree, x: 1950, y: 800, rotation: 0),
    Structure(type: .tree, x: 600, y: 750, rotation: 0),
    Structure(type: .tree, x: 1850, y: 500, rotation: 0),
    Structure(type: .tree, x: 2650, y: 370, rotation: 0),
    Structure(type: .tree, x: 650, y: 3000, rotation: 0),
    Structure(type: .tree, x: 1250, y: 1700, rotation: 0),
    Structure(type: .tree, x: 550, y: 1580, rotation: 0),
    Structure(type: .tree, x: 750, y: 400, rotation: 0),
    Structure(type: .rock, x: 2100, y: 700, rotation: 0),
    Structure(type: .rock, x: 650, y: 1450, rotation: 0),
    Structure(type: .rock, x: 1950, y: 1350, rotation: 0),
    Structure(type: .rock, x: 1400, y: 350, rotation: 0),
    Structure(type: .rock, x: 1300, y: 2660, rotation: 0),
    Structure(type: .rock, x: 1150, y: 2080, rotation: 0),
    Structure(type: .rock, x: 1890, y: 1720, rotation: 0),
    Structure(type: .rock, x: 2690, y: 2620, rotation: 0)
]

public enum ProjectileType {
    case arrow
    case rock
}

struct GoblinConstants {
    static let names = [
        "100%", "130 IQ", "200%", "Abyss", "Ace", "Acid", "Action", "Advanced", "Alien", "Alpha", "Angel", "Angry", "Anomalous", "Apple", "Aquatic", "Arcane", "Assistant to the", "Atypical", "Aunt", "Autumn", "Avenger", "Babe", "Backstreet", "Bad", "Bad Romance", "Baka", "Ballsy", "Bandit", "Barbarian", "Barbie", "Based", "Beautiful", "Beggar", "Belly", "Beta", "Betty", "Big", "Bitter", "Black", "Black Market", "Blasphemous", "Blaster", "Blessed", "Blocky", "Bloody", "Blues", "Bobby", "Bog", "Bold", "Bossy", "Bounty", "Brainless", "Britney", "Bro", "Broken", "Brown", "Buddy", "Bully", "Budget", "Burned", "Buzzing", "Caffeine Addicted", "Calm", "Candy", "Caretaker", "Cannibal", "Cellar", "Century", "Chained", "Charlie", "Charming", "Cheap", "Cherry", "Chili", "Chill", "Classy", "Clean", "Clever", "Clumsy", "Coal", "Cold", "Comedy", "Confused", "Controversial", "Cookie", "Cool", "Copper", "Corn", "Country", "Cousin", "Crazy", "Creamy", "Creepy", "Criminal", "Crumbling", "Crunchy", "Cursed", "Curvy", "Cutie", "Daddy", "Daft", "Damaged", "Dancing", "Dandy", "Danger", "Dappled", "Dark", "Dazed", "Dead", "Death", "Deceiptive", "Decrepit", "Deep", "Despotic", "Determined", "Diesel", "Different", "Diplomat of the", "Dino", "Dire", "Dirty", "Disappearing", "Disco", "Dissident", "Distant", "Disturbed", "Divine", "DJ", "Dodgy", "Doom", "Dorky", "Double", "Drag", "Dread", "Dry", "Dumb", "Dungeon", "Dynamic", "Eastern", "Easy", "Eerie", "Elegant", "Elusive", "Emergency", "Emissary of the", "Emotional", "Empty", "Enchanted", "Endless", "Entirely Chromed", "Ethereal", "Expensive", "Exploding", "Extreme", "Fanatic", "Flaming", "Flat", "Faithful", "Familiar", "Fancy", "Fake", "Fat", "Fearless", "Feral", "Fierce", "Fitness", "Flash", "Flint", "Fluffy", "Foolish", "Foreigner", "Forest", "Forgotten", "Fortune-Telling", "Freelance", "Fried", "Friendly", "Frosty", "Frozen", "Funky", "General", "Generous", "Genius", "Gentle", "Ghost", "Giant", "Gibberish", "Ginger", "Glam", "Glitter", "Gloomy", "Glorious", "Glowing", "Gluten-free", "Golden", "Goo", "Gray", "Great", "Greedy", "Green", "Grumpy", "Grunge", "Guide of the", "Hairy", "Heavy", "Hell Yeah", "Heretic", "Hip-Hop", "Hired", "Holy", "Honest", "Hot", "Huge", "Humble", "Hybrid", "Hyper", "Ice", "Impulsive", "Infamous", "Infected", "Introvert", "Invader", "Itchy", "Iron", "Jazzy", "Jelly", "Joe", "Judo", "Just", "Karate", "Kawaii", "Kind", "Kiss The", "Kung Fu", "Lady", "Lame", "Lazor", "Leather", "Liberated", "Liquid", "Little", "Lonely", "Long", "Looney", "Loud", "Lovely", "Loyal", "Machine", "Mad", "Madame", "Magic", "Mega", "Merchant of", "Metal", "Mighty", "Miracolous", "Miss", "Modern", "Mommy", "Monkey", "Monsieur", "Mountain", "Mr.", "Mutant", "Mystery", "Nanny", "Naomi", "Nasty", "Nebula", "Never Kissed The", "New", "Nice", "Night", "Noisy", "Noob", "Obsessive", "Old", "Outcast", "Paranoid", "Party", "Passion", "Pasta", "Pensive", "Pepper", "Pepperoni", "Perfect", "Personal", "Ping", "Pinky", "Pizza", "Plastic", "Pocket", "Poop", "Poor", "Pop", "Poppy", "Possessed", "Power", "Precious", "Pretty", "Pretty Handsome", "Private", "Protective", "Protestor", "Psycho", "Purple", "Racing", "Radical", "Radioactive", "Rancid", "Rage Against the", "Rap", "Rapid", "Raw", "Ready", "Rebel", "Red Hot Chili", "Reggae", "Reggaeton", "Regular", "Rented", "Revenant", "Revived", "River", "Rock", "Roger", "Roller", "Rocky", "Rotten", "Round", "Rude", "Rufus", "Rusty", "Salty", "Samba", "San Giovanni a Teduccio", "Sadist", "Savage", "Scam", "Scary", "Scoundrel", "Scummy", "Sea", "Secondigliano", "Self", "Self-Destructive", "Seller of", "Servant", "Shame", "Sharp", "Shiny", "Shorty", "Shouting", "Sigma", "Silent", "Silly", "Ska", "Skinny", "Sleepy", "Slim", "Sloppy", "Slurpy", "Smashing", "Smoky", "Soft", "Sold", "Solid", "Spaghetti", "Special", "Speedy", "Spicy", "Spiky", "Spider", "Spinning", "Spirit of the", "Splatter", "Splinter", "Spring", "Square", "Star", "Stealth", "Steam", "Steel", "Stylish", "Stinky", "Stomping", "Stranger", "Strong", "Sugar", "Sugar-Free", "Summer", "Sunny", "Super", "Swag", "Swamp", "Sweaty", "Synthetic", "Tasty", "Telekinetic", "Telepath", "Tender", "The", "The Best", "The Official", "The Only", "The Real", "The Worst", "The Dark Side of the", "Thick", "Thoughtful", "Tiny", "Toilet", "Toon", "Top", "Tormented", "Totti", "Toxic", "Toy", "Trader of", "Trap", "Traumatic", "Tribal", "Triple", "Turbo-Charged", "Typical", "Ultimate", "Uncle", "Undead", "Unexpected", "Virtual", "Visionary", "Waking", "Walking", "Washing", "Wasted", "Weak", "Wealthy", "Weelchair Driver", "Well Known", "Well Loved", "Well Spoken", "Western", "Wet", "Whispering", "Wiggly", "Wild", "Windy", "Winnie", "Winter", "Wobbling", "Wonder", "Woody", "Wounded", "Wrinkly", "Yellow", "Young", "Yummy", "Zombie", "Zumba"
    ]
    static let surnames = [
        "Abigail", "Actor", "Admirer", "Ale", "Alessandro", "Ambusher", "Ant", "Apricot", "Aristocrat", "Arrow", "Arsonist", "Artist", "Ash", "Assassin", "Athlete", "Avocado", "Bae", "Baguette", "Bartender", "Bat", "Bald", "Banana", "Baobab", "Bard", "Bark", "Beach", "Bean", "Beard", "Beast", "Belch", "Bell", "Berry", "Birb", "Biscuit", "Bite", "Blackmailer", "Blacksmith", "Blade", "Blaze", "Bomb", "Bone", "Boom","Boop", "Boots", "Bottom", "Brain", "Breaker", "Breath", "Bro", "Brony", "Broom", "Bruise", "Bubbles", "Bug", "Bull", "Burp", "Butterfly", "Button", "Cake", "Canary", "Cannon", "Caper", "Catcher", "Cauliflower", "Celebrity", "Chad", "Champ", "Cheek", "Chef", "Chick", "Chicken", "Chin", "Chip", "Clapper", "Cleric", "Cloud", "Clover", "Clown", "Clubber", "Coconut", "Coder", "Coffee", "Comet", "Companion", "Conqueror", "Corpse", "Cow", "Crab", "Cream", "Crocodile", "Cry", "Cub", "Cucumber", "Dagger", "Dancer", "Danger", "Deluxe", "Designer", "Diva", "Donut", "Dot", "Droplet", "Druid", "Duck", "Dude", "Dumpling", "Ears", "Eater", "Eel", "Egg", "Eggnog", "Emblem", "Enforcer", "Eugenio", "Experiment", "Explorer", "Eyeball", "Fart", "Feet", "Fennel", "Finger", "Fish", "Fist", "Flake", "Foam", "Fool", "Fox", "Freckles", "Frog", "Fuel", "Gardener", "Ghost", "Gibbon", "Giuseppe", "Gloves", "Goblin", "Goblin Things", "Golem", "Grabber", "Grasshopper", "Gravedigger", "Grime", "Grin", "Grower", "Guard", "Guardian", "Gull", "Ham", "Headbutt", "Heart", "Hedonist", "Hermit", "Hero", "Hippo", "Hoot", "Hopper", "Horn", "Horse", "Hot-Dog", "Hunter", "Hurricane", "Idol", "Impostor", "Jam", "Jello", "Jellyfish", "Jester", "Juice", "Karen", "Katana", "Kebab", "Keeper", "Kid", "Killer", "Kitty", "Knee", "Knife", "Leaf", "Lime", "Lizard", "Lizzy", "Lobster", "Luca", "Luigi", "Lullaby", "Mage", "Maiden", "Mango", "Mantis", "Martyr", "Mask", "Master", "Mate", "Meatball", "Melon", "Merchant", "Messiah", "Mobster", "Model", "Mold", "Mole", "Monk", "Moose", "Mouse", "Mud", "Mummy", "Mushroom", "Musk", "Moustache", "Nails", "Newt", "Nipple", "Noble", "Nose", "Omelette", "Onion", "Pain", "Painter", "Paladin", "Panties", "Paper", "Parrot", "Parsley", "Pea", "Peel", "Perchiazzi", "Performer", "Perna", "Pet", "Pickle", "Pie", "Pigeon", "Piglett", "Pilot", "Pirate", "Plancton", "Platypus", "Politician", "Pong", "Pooh", "Potato", "Priest", "Prisoner", "Prodigy", "Prophet", "Prune", "Puke", "Pumpkin", "Punk", "Puppet", "Puppy", "Puzzle", "Pyromancer", "Quokka", "Rabbit", "Rainbow", "Ranger", "Rapper", "Rat", "Riccardo", "Rigger", "Ring", "Rival", "Roach", "Robber", "Rocket", "Rogue", "Rooster", "Rope", "Rubber", "Ruler", "Runner", "Sage", "Sandwich", "Santo", "Scam", "Scar", "Scorn", "Scout", "Scum", "Sea Foam", "Seed", "Senpai", "Sensei", "Shades", "Shaker", "Shaman", "Shampoo", "Shield", "Shoes", "Shooter", "Shower", "Shrimp", "Singer", "Sis", "Skater", "Skunk", "Sky", "Slap", "Slice", "Slug", "Smasher", "Smile", "Smuggler", "Snake", "Sniper", "Soda", "Soldier", "Sommelier", "Sorcerer", "Soup", "Spanker", "Spark", "Spear", "Spine", "Spit", "Spoon", "Sprout", "Spy", "Squirrel", "Star", "Stepper", "Stick", "Sting", "Stomper", "Storm", "Summoner", "Sunrise", "Sunset", "Surprise", "Swine", "Sword", "Tail", "Tailor", "Tamer", "Tank", "Tea", "Tension", "Thief", "Thug", "Tiago", "Toe", "Tomato", "Tool", "Tooth", "Tornado", "Tactician", "Tortoise", "Tourist", "Trailblazer", "Trip", "Turkey", "Turnip", "Turtle", "Twig", "Tyrant", "Veteran", "Victim", "Vigilante", "Walker", "Wallaby", "Wanderer", "Warrior", "Watermelon", "Web", "Witch", "Wizard", "Wolf", "Worker", "Writer", "Wurm", "X", "X Æ A-12", "Yogurt", "Zapper", "Zork"
    ]
    static let honoree = [
        "Admin.", "Asst.", "CEO", "CFO", "Dir.", "Doc.", "Eng.", "Exec.", "Master", "Mgr.", "Off.", "PM", "Pres.", "Prof.", "VP"
    ]
    static let emotions = [
        "a moment of peace",
        "accomplishment in life",
        "allergy to pointless speeches",
        "appetite for destruction",
        "blame",
        "blessed by the sunlight",
        "bothered by its own existence",
        "breaking the law",
        "broken",
        "catapulted with memories to its happy childhood that will never return again",
        "chill",
        "constantly watched and judged by something above",
        "corrupted by rampant consumerism",
        "disappointed",
        "disconnected from the real world",
        "dismayed and embittered",
        "doomed",
        "embarass",
        "emotional",
        "emotionally off",
        "emotionally vulnerable",
        "empty",
        "extreme reckless temptation",
        "fascinated by the beauty in the world",
        "fast and furious",
        "fatal attraction to toxic relationships",
        "fear of self",
        "fear of the dark",
        "fear of the unknown",
        "fragile",
        "frightened",
        "harmless",
        "hopeless",
        "hopelessly sad",
        "humiliation",
        "hunger cramps",
        "hurt in ways that no one can know",
        "hyperactivity",
        "hypocrisy",
        "immeasurable happiness",
        "in a midlife crisis",
        "in panic",
        "inner darkness",
        "inspired by the social downfall of others",
        "irreplaceable",
        "isolation and loneliness",
        "judged by the outfit",
        "like living in a game",
        "like living in a lie",
        "like forgetting its own life piece after piece",
        "like losing hope in justice",
        "lost",
        "love",
        "misunderstood",
        "obsessive jealousy",
        "old",
        "passionate about rocks",
        "powerful",
        "pride and prejudice",
        "rad",
        "seductive",
        "self-pity",
        "self-respect",
        "shame",
        "shocked by the neighbours attitude",
        "sorry",
        "strange",
        "strong enough to bear the burdens of duty",
        "surprise",
        "that sensation when you know you are wrong",
        "that sensation when you have to poop but there's no bathroom nearby",
        "the corruption of its soul",
        "the desire to fly",
        "the downfall of civilizations",
        "the need for speed",
        "the need to avenge the honor of its house",
        "the nostalgia of the maternal warmth of the Cauldronn",
        "the pointless meaning of existence",
        "the rush of adrenaline in the veins",
        "the sound of silence",
        "the truest meaning of Christmas",
        "the urge of cuddles",
        "the urge to polemize",
        "the vertigo of falling",
        "the void",
        "timidly careless in a cute way",
        "trapped in a body it doesn't recognize as its own",
        "unconditional love",
        "uncontrollably hilarious",
        "under control",
        "valuable",
        "very angry",
        "wasted",
        "way too generous",
        "weak",
        "without infamy or praise",
        "young"
    ]
    static let places = [
        "a box",
        "a fashion show",
        "a glacier with a frozen mammooth",
        "a maze",
        "a rave",
        "a rural idyll",
        "a sausage festival",
        "a sea of troubles",
        "a sinking ship",
        "a stariway to Heaven",
        "a yellow sub-boat",
        "an island",
        "Hell",
        "High School",
        "homeland",
        "one of those eastern bard dance routines",
        "prison",
        "the ancient ruins",
        "the anonymous club",
        "the attic",
        "the ballroom",
        "the basement",
        "the bathroom",
        "the battleground",
        "the bed",
        "the bed of the gnome Princess",
        "the belly of a dragon",
        "the black market",
        "the candy shop",
        "the carnvial",
        "the cat litter",
        "the Cauldronn",
        "the charity hospital",
        "the church",
        "the circus",
        "the council of wizards",
        "the countryside",
        "the criminal network",
        "the Dark One's dungeon",
        "the Dark One's hand",
        "the Dark One's manor",
        "the darkest spot of its heart",
        "the depths of the Ocean",
        "the dining room",
        "the dog kennel",
        "the eye of a tornado",
        "the fog",
        "the gnome cave",
        "the Goblin Academy",
        "the Globe Earth conspirationists yearly summit",
        "the Globe Earth cult",
        "the farm",
        "the fifth dimension",
        "the fitness gym",
        "the forest",
        "the highest building in the Citadel",
        "the innermost region of the mind",
        "the jungle",
        "the King's stables",
        "the magic workshop",
        "the military camp",
        "the mirror",
        "the mushrooms bank",
        "the needlework club",
        "the opera",
        "the pet sematary",
        "the prison",
        "the public pool",
        "the Queen's throne",
        "the savannah",
        "the school trip",
        "the shadows",
        "the shantytown",
        "the siege",
        "the staircase",
        "the strawberry field",
        "the street parade",
        "the tavern",
        "the Troll nursery",
        "the underwold district",
        "the war"
    ]
    static let stuff = [
        "1000 pieces puzzles",
        "a box",
        "a bunch of rocks",
        "a contagion",
        "a doll",
        "a pair of gloves",
        "a skull",
        "an egg",
        "angry birds",
        "animal fat soap",
        "bachelor's degree",
        "banana bread",
        "bird poo",
        "blades",
        "board games",
        "brain",
        "bread crumbs",
        "chocolate chip",
        "cookbooks",
        "concrete",
        "corn flakes",
        "crude oil",
        "deadly traps",
        "denture",
        "divorced parents",
        "drones",
        "ducks",
        "ermine cloak",
        "expensive art",
        "expired milk",
        "flowers",
        "fresh tuna",
        "grandmother's amulet",
        "grape juice",
        "guacamole sauce",
        "horses",
        "leather balls",
        "leather jacket",
        "mud",
        "nails",
        "olive oil",
        "out of tune lutes",
        "peacock feathers",
        "pest rats",
        "pizza diavola",
        "poison",
        "poisonous arrows",
        "pork ribs",
        "portals",
        "pumpkin seeds",
        "ramen",
        "riddles",
        "roast chestnuts",
        "roots, mosses and lichens",
        "rotten meat",
        "sand",
        "scarecrows dressed as fancy housewives",
        "secrets",
        "shells",
        "slime",
        "soap",
        "songs",
        "spectacular abs",
        "stinky cabbage",
        "straw",
        "swimsuits",
        "teeth",
        "tentacles",
        "the crown",
        "the One Ring",
        "tomatoes",
        "torches and pitchforks",
        "toothpicks",
        "underarm deodorant",
        "used syringes",
        "wasted yogurt",
        "wingless birds"
    ]
}

struct GoblinActivity {
    let activity: [String]
    
    init(randomGoblin: String) {
        self.activity = [
            "faking its own death",
            "jumping on rooftops to feel \(GoblinConstants.emotions.randomElement()!)",
            "throwing \(GoblinConstants.stuff.randomElement()!) at passerby with \(randomGoblin)",
            "watching \(GoblinConstants.stuff.randomElement()!) while sipping hot tea",
            "solving crosswords and sudoku with \(randomGoblin)",
            "living in a hut made of \(GoblinConstants.stuff.randomElement()!) and \(GoblinConstants.stuff.randomElement()!)",
            "being heated by the breath of \(randomGoblin)",
            "collecting livers and kidneys from its victims",
            "dancing frantically without music to feel \(GoblinConstants.emotions.randomElement()!)",
            "fishing with bare hands",
            "performing the art of mime",
            "pretending to have \(GoblinConstants.stuff.randomElement()!)",
            "howling at the Moon",
            "spreading Globe Earth conspiracies",
            "relaxing in a hot thub after shaving",
            "feeling \(GoblinConstants.emotions.randomElement()!)",
            "stealing meds at the charity hospital",
            "teaching golems to feel \(GoblinConstants.emotions.randomElement()!)",
            "wasting money in invisiblecurrencies",
            "speculating on \(GoblinConstants.stuff.randomElement()!) prices",
            "sneak eating \(randomGoblin)'s snacks",
            "celebrating the athleticism of \(randomGoblin)'s body in motion",
            "celebrating the anniversary of the invention of \(GoblinConstants.stuff.randomElement()!)",
            "obeying the Dark One's orders",
            "being thrown by the Dark One's hand",
            "bingereading romantic soap phamplets",
            "feeling \(GoblinConstants.emotions.randomElement()!) in \(GoblinConstants.places.randomElement()!) within the arms of \(randomGoblin)",
            "being spoiled by \(randomGoblin)",
            "stealing candies from children",
            "selling magic vacuum-brooms door-to-door",
            "exchanging \(GoblinConstants.stuff.randomElement()!) for a handful of magic beans",
            "sleeping until it can remember its own real life",
            "singing exclusively in falsetto",
            "going to sleep wearing just a drop of luxury perfume",
            "hopping among flowers while playing clarinet",
            "headbanging",
            "looking for pennies forgotten as change in snack stands",
            "communicating only with facial expressions in letters",
            "feeling \(GoblinConstants.emotions.randomElement()!) because of too much coffee",
            "jumping on the bed at sleepovers",
            "crying in \(GoblinConstants.places.randomElement()!) in the middle of the night",
            "opening walnuts with teeth",
            "losing hair",
            "chewing gums in a desperate attempt to skip meals",
            "carving coral to create luxury tinsel in \(GoblinConstants.stuff.randomElement()!) shape",
            "growing carrots to gnaw them like a rabbit",
            "throwing \(GoblinConstants.stuff.randomElement()!) at pigeons",
            "feeling \(GoblinConstants.emotions.randomElement()!) because of \(randomGoblin) actions",
            "feeling \(GoblinConstants.emotions.randomElement()!) when \(randomGoblin) is nearby",
            "shivering because it feels \(GoblinConstants.emotions.randomElement()!)",
            "feeding \(randomGoblin) with \(GoblinConstants.stuff.randomElement()!)",
            "removing dead skin from \(randomGoblin)'s body",
            "watching stars with \(randomGoblin) at \(GoblinConstants.places.randomElement()!)",
            "using \(GoblinConstants.stuff.randomElement()!) as make-up",
            "having a good time with \(randomGoblin) because they feel \(GoblinConstants.emotions.randomElement()!)",
            "inventing a new energy drink that tastes of \(GoblinConstants.stuff.randomElement()!)",
            "writing a novel called 'Goblin Potter and the Chamber of \(GoblinConstants.stuff.randomElement()!)'",
            "loving the smell of \(GoblinConstants.stuff.randomElement()!) in the morning",
            "hiding \(GoblinConstants.stuff.randomElement()!) in \(GoblinConstants.places.randomElement()!)",
            "showing up at first dates with \(GoblinConstants.stuff.randomElement()!)",
            "needing to feel \(GoblinConstants.emotions.randomElement()!)",
            "being attached to \(randomGoblin) to get \(GoblinConstants.emotions.randomElement()!)",
            "hiding a secret tattoo that portrays \(randomGoblin) with \(GoblinConstants.stuff.randomElement()!), a work of art that means feeling \(GoblinConstants.emotions.randomElement()!)",
            "hugging \(randomGoblin) in \(GoblinConstants.places.randomElement()!)",
            "learning to fly",
            "undergoing plastic surgery to look like \(randomGoblin)",
            "playing hide and seek with \(randomGoblin) in \(GoblinConstants.places.randomElement()!)",
            "going shopping with \(randomGoblin) to buy \(GoblinConstants.stuff.randomElement()!)",
            "killing in the name of the Dark One",
            "consuming \(GoblinConstants.stuff.randomElement()!) as Cauldronn fuel",
            "taking a long, hot shower to stop feeling \(GoblinConstants.emotions.randomElement()!)",
            "eating \(GoblinConstants.stuff.randomElement()!) and \(GoblinConstants.stuff.randomElement()!)",
            "using \(randomGoblin) as pin punch",
            "burning \(GoblinConstants.stuff.randomElement()!) as tribute to the Dark One",
            "spreading lies about \(randomGoblin)",
            "finding hope in \(GoblinConstants.stuff.randomElement()!)",
            "bringing despair in \(GoblinConstants.places.randomElement()!)",
            "escaping from \(GoblinConstants.places.randomElement()!)",
            "erasing the memory of that day it felt \(GoblinConstants.emotions.randomElement()!)",
            "creating a better version of \(GoblinConstants.stuff.randomElement()!)",
            "revealing the dangers of \(GoblinConstants.stuff.randomElement()!)",
            "stealing \(GoblinConstants.stuff.randomElement()!) from \(randomGoblin)'s home",
            "protecting \(randomGoblin) from the issues of \(GoblinConstants.stuff.randomElement()!)",
            "revealing the good in \(randomGoblin)",
            "obtaining \(GoblinConstants.stuff.randomElement()!) as source of power",
            "committing minor crimes with \(randomGoblin)",
            "breading and frying \(GoblinConstants.stuff.randomElement()!)",
            "ending \(randomGoblin)'s evil schemes in getting \(GoblinConstants.emotions.randomElement()!)",
            "risking to lose its precious \(GoblinConstants.stuff.randomElement()!) to save \(randomGoblin)'s life",
            "learning to love again",
            "confessing its sins to \(randomGoblin)",
            "facing its deepst fear: \(GoblinConstants.stuff.randomElement()!)",
            "swearing loyalty to the Dark One",
            "gaining enemies attention in \(GoblinConstants.places.randomElement()!)",
            "learning to trust its capabilities when it feels \(GoblinConstants.emotions.randomElement()!)",
            "setting \(GoblinConstants.stuff.randomElement()!) on fire to feel \(GoblinConstants.emotions.randomElement()!)",
            "paying \(randomGoblin)'s gambling debts",
            "driving the spirit that possesses \(randomGoblin)'s soul",
            "imprisoning \(randomGoblin) in \(GoblinConstants.places.randomElement()!)",
            "enchanting \(GoblinConstants.stuff.randomElement()!)",
            "sculpting a statue out of \(GoblinConstants.stuff.randomElement()!), which resembles \(randomGoblin)'s features when it feels \(GoblinConstants.emotions.randomElement()!)",
            "starting a war for the monopoly of \(GoblinConstants.stuff.randomElement()!)",
            "mapping the entire history of \(GoblinConstants.places.randomElement()!)",
            "sabotaging the Gnomes using just \(GoblinConstants.stuff.randomElement()!)",
            "stopping the Gnomes from reaching \(GoblinConstants.places.randomElement()!)",
            "using \(GoblinConstants.stuff.randomElement()!) as spell component to cast that magic that let you feel \(GoblinConstants.emotions.randomElement()!)",
            "putting \(GoblinConstants.places.randomElement()!) to the torch",
            "overcoming its fear of \(GoblinConstants.stuff.randomElement()!)",
            "planting a bomb in \(GoblinConstants.places.randomElement()!)",
            "exploring \(GoblinConstants.places.randomElement()!) with \(randomGoblin)",
            "exploring \(GoblinConstants.places.randomElement()!) alone to feel \(GoblinConstants.emotions.randomElement()!)",
            "inventing a new kind of \(GoblinConstants.stuff.randomElement()!)",
            "creating a new weapon out of \(GoblinConstants.stuff.randomElement()!)",
            "being trapped in \(GoblinConstants.places.randomElement()!) since childhood",
            "adopting \(GoblinConstants.stuff.randomElement()!) as its emblem",
            "adopting \(GoblinConstants.places.randomElement()!) as home"
        ]
    }
}

struct GoblinDescription {
    let description: String
    
    init(name: String, randomGoblin1: String, randomGoblin2: String) {
        let activity = GoblinActivity(randomGoblin: randomGoblin2).activity.randomElement()!
        self.description = [
            "\(name) enjoys \(activity).",
            "\(name) has won several prizes for \(activity).",
            "\(name) is inspired by the deeds of \(randomGoblin1).",
            "\(name) is not always in the mood for \(activity).",
            "\(name) is \(randomGoblin1)'s best friend.",
            "\(name) is well known for \(activity).",
            "\(name) wants to attend the Goblin Academy just for \(activity).",
            "\(name) stalks \(randomGoblin1) every night.",
            "\(name) is doubtful about \(activity).",
            "\(name) considers itself as the leader of \(activity).",
            "\(name) is always comfortable about \(activity).",
            "\(name) is considered the best interpeter of \(activity).",
            "\(name) has been showing off in \(activity).",
            "\(name) reads novels about \(activity).",
            "\(name) is following the steps of \(randomGoblin1).",
            "\(name) wants to take advantage of \(randomGoblin1) for its personal gain.",
            "\(name) is talented for \(activity).",
            "No one trusts \(name) because it is suspected of \(activity).",
            "\(name) is always professional when \(activity).",
            "Can't blame \(name) for \(activity) because \(name) is just the way it is.",
            "Since yesterday, \(activity) is the ideal goal in \(name)'s life.",
            "\(name) thinks that \(activity) is very important.",
            "\(name) spends its entire life \(activity).",
            "\(name) doesn't care about \(randomGoblin1) in any way.",
            "\(name) claims to date \(randomGoblin1), but actually is secretly in love with \(randomGoblin2)",
            "\(name) lacks any respect for \(randomGoblin1)",
            "\(name) now is ready for \(activity).",
            "Currently, \(name) has a great deal of respect for \(activity).",
            "\(name) is constantly disgusted by \(activity).",
            "\(name) feels always deeply offended by those who enjoy \(activity).",
            "For \(name) every time is a good chance for \(activity).",
            "\(name) prefers \(activity) on a daily basis.",
            "\(name) thinks that \(activity) defines the good character of an individual.",
            "\(name) doesn't care about anything but \(activity).",
            "\(name) constantly dreams about \(activity).",
            "\(name) has become obsessed with \(activity).",
            "\(name) thinks that \(activity) is better than nothing.",
            "\(randomGoblin1) can't stop \(name) from \(activity).",
            "\(randomGoblin1)'s envy is \(name)'s strength.",
            "\(name) is always overexcited for \(activity).",
            "\(name) has an issue with \(activity).",
            "\(name) is challenging \(randomGoblin1) in \(activity).",
            "\(name)'s grandma always said that \(activity) would have ruined its life.",
            "\(name)'s life has changed forever when \(randomGoblin1) pushed it in \(activity).",
            "\(name) needs some advices in \(activity).",
            "\(name) is here to spread the word of \(randomGoblin1).",
            "Rather than going to its mother-in-law, \(name) prefers \(activity).",
            "\(name) is conspiring against \(randomGoblin1) to force it \(activity).",
            "\(name) skipped leg day at the fitness gym because it was \(activity).",
            "\(name) wants to unravel the mistery of \(activity).",
            "\(name) could expose \(randomGoblin1) secrets.",
            "\(name) is working hard on \(activity).",
            "\(name) is focusing in \(activity), just to draw \(randomGoblin1)'s attention.",
            "\(name) wants to solve \(randomGoblin1)'s problem about \(activity).",
            "\(name) could betray \(randomGoblin1) by \(activity).",
            "\(name) wants to improve the reputation of the Dark Kid by \(activity).",
            "\(name) is getting fame from \(activity).",
            "\(name) has a secret plan about \(activity).",
            "\(name) wants to reconcile with its old enemy \(randomGoblin1).",
            "\(name) could die for its closest friend \(randomGoblin1).",
            "\(name) always expose the importance of \(activity).",
            "\(name) has been rejected from its Goblin community because it was \(activity).",
            "\(name) is \(activity) for the wrong reasons.",
            "No one knows the reasons why \(name) is \(activity).",
            "\(name) can't resist the temptation of \(activity).",
            "Last time \(name) was \(activity), it ended in humiliation.",
            "Probably, \(activity) will cost \(name)'s soul.",
            "\(name)'s reputation is going down because it is \(activity).",
            "\(name) is paying the price of \(randomGoblin1)'s deeds.",
            "\(name) is running away from its responsibilities because it was \(activity).",
            "\(name) broke \(randomGoblin1)'s promise of \(activity).",
            "\(name) will never forgive \(randomGoblin1) for \(activity).",
            "\(name) likes when innocents suffer for its role in \(activity).",
            "Probably, \(name) will lose its mental health in \(activity).",
            "\(name) blames \(randomGoblin1) regarding of \(activity).",
            "\(name) lost \(randomGoblin1)'s respect for \(activity).",
            "\(name) wants to convince the Gnomes about \(activity).",
            "\(name) is pushing \(randomGoblin1) away from \(activity).",
            "\(name) is punishing \(randomGoblin1) by forcing it \(activity).",
            "\(name) bears the scars of \(activity).",
            "\(name) was exiled because it has been caught while \(activity).",
            "\(name) pledged its life in service of \(randomGoblin1).",
            "\(name) pledged its life in \(activity).",
            "\(name) tosses coins to \(randomGoblin1) every time it is \(activity).",
            "The Dark One punished \(name) for \(activity).",
            "This is \(name)'s last adventure before retiring.",
            "\(name) never finds peace when \(activity).",
            "\(name)'s only weakness is \(activity).",
            "\(name) had a vision of \(randomGoblin1) \(activity).",
            "\(name) is learning the Gnomish language for \(activity).",
            "\(name) is blackmailing \(randomGoblin1) to force it \(activity).",
            "The only thing \(name) is remembered for, is \(activity).",
            "\(name) is the Goblin that released \(randomGoblin1) from its containment.",
            "\(name) was found exhausted on the doorstep of \(randomGoblin1) after \(activity).",
            "\(name) has been trained by \(randomGoblin1) in \(activity).",
            "\(name) has been indoctrinated by \(randomGoblin1) in \(activity).",
            "\(name) woved revenge on \(randomGoblin1) after it ended \(activity).",
            "\(name) was raised by \(randomGoblin1) whit the goal of \(activity).",
            "\(name) has always a recurring dream about \(activity).",
            "\(name) is the subject of a prophecy about \(activity).",
            "\(name) was in love with \(randomGoblin1), but now is happy with \(randomGoblin2).",
            "\(randomGoblin1) broke \(name)'s heart.",
            "After \(activity), \(name) owes a lifelong debt to \(randomGoblin1).",
            "\(name) has been cursed by \(randomGoblin1).",
            "\(name) lost its parents when \(activity).",
            "\(name) is learning the secrets of \(activity).",
            "\(name)'s family finded out it is \(activity).",
            "The law is investigating in \(name) actions about \(activity)."
        ].randomElement()!
    }
}

struct GoblinFirstGenDescription {
    let description: String
    
    init(name: String) {
        self.description = [
            "\(name) enjoys teaching golems to feel love.",
            "\(name) has won several prizes for throwing tomatoes at pigeons.",
            "\(name) is not always in the mood for being thrown by the Dark One's hand.",
            "\(name) is well known for headbanging.",
            "\(name) is enrolled at the Goblin Academy just for looking for pennies forgotten as change in snack stands.",
            "\(name) is doubtful about howling at the Moon.",
            "\(name) likes chewing gums in a desperate attempt to skip meals.",
            "\(name) considers itself as the leader of losing hair.",
            "\(name) is always comfortable about stealing candies from children.",
            "\(name) is considered the best interpreter of performing the art of mime.",
            "\(name) has been showing off in faking its own death.",
            "\(name) reads novels about collecting livers and kidneys from victims.",
            "\(name) is talented for stealing meds at the charity hospital.",
            "No one trusts \(name) because it is suspected of jumping on beds at sleepovers.",
            "\(name) is always professional when opening walnuts with teeth.",
            "Rather than going to ist mother-in-law, \(name) prefers dancing frantically without music to feel disconnected from the real world.",
            "\(name) feels always deeply offended by those who enjoy showing up at first dates with bachelor's degree.",
            "\(name) needs some advices in feeling the truest meaning of Christmas.",
            "\(name) thinks that fishing with bare hands is very important.",
            "\(name) is always overexcited for celebrating the anniversary of the invention of spectacular abs.",
            "\(name) is doubtful about inventing a new energy drink that tastes of soap.",
            "\(name) likes being thrown by the Dark One's hand.",
            "Since yesterday, headbanging is the ideal goal in \(name)'s life.",
            "\(name) constantly dreams about communicating only with facial expressions in letters.",
            "\(name) spends its entire life in shivering because of feeling the pointless meaning of existence.",
            "\(name) enjoys watching nails while sipping hot tea.",
            "Since yesterday, singing exclusively in falsetto is the ideal goal in \(name)'s life.",
            "\(name) is well known for performing the art of mime.",
            "\(name) reads novels about showing up at first dates with pest rats.",
            "Can't blame \(name) for crying in the bathroom in the middle of the night because \(name) is just the way it is.",
            "\(name) has become obsessed with hiding bird poo in the cat litter.",
            "\(name) doesn't care about anything but learning to fly.",
            "\(name) prefers headbanging on a daily basis.",
            "\(name) thinks that jumping on the bed at sleepovers is very important.",
            "For \(name) every time is a good chance for taking a long, hot shower to get rid of feeling emotionally off.",
            "Can't blame \(name) for killing in the name of the Dark One because \(name) is just the way it is.",
            "\(name) likes feeling in a midlife crisis because of too much coffee.",
            "No one trusts \(name) because it is suspected of spreading Globe Earth conspiracies.",
            "\(name) likes dancing frantically without music to feel embarass.",
            "For \(name) every time is a good chance for losing hair.",
            "\(name) likes speculating on olive oil prices.",
            "\(name) thinks that pretending to have divorced parents defines the good character of an individual.",
            "\(name)'s grandma always said that stealing meds at the charity hospital would have ruined its life.",
            "\(name) needs some advices in fishing with bare hands.",
            "\(name) likes killing in the name of the Dark One.",
            "\(name) spends its entire life communicating only with facial expressions in letters.",
            "\(name) needs some advices in using mud as make-up.",
            "\(name) thinks that being thrown by the Dark One's hand is better than nothing.",
            "\(name) thinks that selling magic vacuum-brooms door-to-door is better than nothing.",
            "For \(name) every time is a good chance for pretending to have divorced parents.",
            "\(name) doesn't care about anything but feeling that sensation when you have to poop but there's no bathroom nearby.",
            "\(name) skipped leg day at the fitness gym because of faking its own death.",
            "\(name) skipped leg day at the fitness gym because of speculating on wasted yogurt prices.",
            "\(name) has an issue with exchanging swimsuit for a handful of magic beans.",
            "\(name) is working hard on showing up at first dates with fresh tuna."
        ].randomElement()!
    }
}
