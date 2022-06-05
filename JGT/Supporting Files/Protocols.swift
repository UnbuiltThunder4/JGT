//
//  Protocols.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 05/06/22.
//

protocol AudioPlayer {
    
    var musicVolume: Float { get set }
    func play(music: Music)
    func pause(music: Music)
    
    var effectsVolume: Float { get set }
    func play(effect: Effect)
}

public protocol SoundFile {
    var filename: String { get }
    var type: String { get }
}

public struct Music: SoundFile {
    public var filename: String
    public var type: String
}

public struct Effect: SoundFile {
    public var filename: String
    public var type: String
}

//ALL AUDIO FILES

struct Audio {
    
    struct MusicFiles {
        static let background = Music(filename: "Psycho Katana - Instrumental", type: "wav")
    }
    
    struct EffectFiles {
        static let axeGnomeAttack = Effect(filename: "axe-gnome-attack", type: "mp3")
        static let catapultLaunch = Effect(filename: "catapult-launch", type: "wav")
        static let catapultStoneImpact = Effect(filename: "catapult-stone-impact", type: "mp3")
        static let catapultStretch = Effect(filename: "catapult-stretch", type: "wav")
        static let cauldronn = Effect(filename: "cauldronn", type: "mp3")
        static let darkSonAttack = Effect(filename: "dark-son-attack", type: "mp3")
        static let darkSonGateDestroyed = Effect(filename: "dark-son-gate-destroyed", type: "mp3")
        static let darkSonGrunt = Effect(filename: "dark-son-grunt", type: "mp3")
        static let darkSonRebirth = Effect(filename: "dark-son-rebirth", type: "mp3")
        static let flameblinBurn1 = Effect(filename: "flameblin-burn-1", type: "wav")
        static let flameblinBurn2 = Effect(filename: "flameblin-burn-2", type: "wav")
        static let flameblinCandy1 = Effect(filename: "flameblin-candy-1", type: "wav")
        static let flameblinCandy2 = Effect(filename: "flameblin-candy-2", type: "wav")
        static let flameblinCatapult1 = Effect(filename: "flameblin-catapult-1", type: "wav")
        static let flameblinCatapult2 = Effect(filename: "flameblin-catapult-2", type: "wav")
        static let flameblinDeath1 = Effect(filename: "flameblin-death-1", type: "wav")
        static let flameblinDeath2 = Effect(filename: "flameblin-death-1", type: "wav")
        static let flameblinFly1 = Effect(filename: "flameblin-fly-1", type: "wav")
        static let flameblinFly2 = Effect(filename: "flameblin-fly-2", type: "wav")
        static let flameblinFly3 = Effect(filename: "flameblin-fly-3", type: "wav")
        static let flameblinFrenzy1 = Effect(filename: "flameblin-frenzy-1", type: "wav")
        static let flameblinFrenzy2 = Effect(filename: "flameblin-frenzy-2", type: "wav")
        static let flameblinFrenzy3 = Effect(filename: "flameblin-frenzy-3", type: "wav")
        static let flameblinGraduation1 = Effect(filename: "flameblin-graduation-1", type: "wav")
        static let flameblinGraduation2 = Effect(filename: "flameblin-graduation-2", type: "wav")
        static let flameblinGraduation3 = Effect(filename: "flameblin-graduation-3", type: "wav")
        static let flameblinHit1 = Effect(filename: "flameblin-hit-1", type: "wav")
        static let flameblinHit2 = Effect(filename: "flameblin-hit-2", type: "wav")
        static let flameblinHit3 = Effect(filename: "flameblin-hit-3", type: "wav")
        static let flameblinPress1 = Effect(filename: "flameblin-press-1", type: "wav")
        static let flameblinPress2 = Effect(filename: "flameblin-press-2", type: "wav")
        static let flameblinPress3 = Effect(filename: "flameblin-press-3", type: "wav")
        static let flameblinSelfCatapult1 = Effect(filename: "flameblin-self-catapult-1", type: "wav")
        static let flameblinSelfCatapult2 = Effect(filename: "flameblin-self-catapult-2", type: "wav")
        static let flameblinSelfCatapult3 = Effect(filename: "flameblin-self-catapult-3", type: "wav")
        static let flameblinStone1 = Effect(filename: "flameblin-stone-1", type: "wav")
        static let flameblinTransform1 = Effect(filename: "flameblin-transform-1", type: "wav")
        static let frenzyTavern = Effect(filename: "frenzy-tavern", type: "wav")
        static let goblinBurn1 = Effect(filename: "goblin-burn-1", type: "wav")
        static let goblinCandy1 = Effect(filename: "goblin-candy-1", type: "wav")
        static let goblinCatapult1 = Effect(filename: "goblin-catapult-1", type: "wav")
        static let goblinDeath1 = Effect(filename: "goblin-death-1", type: "wav")
        static let goblinDeath2 = Effect(filename: "goblin-death-2", type: "wav")
        static let goblinFear1 = Effect(filename: "goblin-fear-1", type: "wav")
        static let goblinFly1 = Effect(filename: "goblin-fly-1", type: "wav")
        static let goblinFly2 = Effect(filename: "goblin-fly-2", type: "wav")
        static let goblinFrenzy1 = Effect(filename: "goblin-frenzy-1", type: "wav")
        static let goblinGraduation1 = Effect(filename: "goblin-graduation-1", type: "wav")
        static let goblinHit1 = Effect(filename: "goblin-hit-1", type: "wav")
        static let goblinHit2 = Effect(filename: "goblin-hit-2", type: "wav")
        static let goblinHit3 = Effect(filename: "goblin-hit-3", type: "wav")
        static let goblinPress1 = Effect(filename: "goblin-press-1", type: "wav")
        static let goblinSelfCatapult1 = Effect(filename: "goblin-self-catapult-1", type: "wav")
        static let goblinStone1 = Effect(filename: "goblin-stone-1", type: "wav")
        static let gumblinBurn1 = Effect(filename: "gumblin-burn-1", type: "wav")
        static let gumblinCatapult1 = Effect(filename: "gumblin-catapult-1", type: "wav")
        static let gumblinDeath1 = Effect(filename: "gumblin-death-1", type: "wav")
        static let gumblinDeath2 = Effect(filename: "gumblin-death-2", type: "wav")
        static let gumblinFear1 = Effect(filename: "gumblin-fear-1", type: "wav")
        static let gumblinFear2 = Effect(filename: "gumblin-fear-2", type: "wav")
        static let gumblinFear3 = Effect(filename: "gumblin-fear-3", type: "wav")
        static let gumblinFly1 = Effect(filename: "gumblin-fly-1", type: "wav")
        static let gumblinFrenzy1 = Effect(filename: "gumblin-frenzy-1", type: "wav")
        static let gumblinGraduation1 = Effect(filename: "gumblin-graduation-1", type: "wav")
        static let gumblinHit1 = Effect(filename: "gumblin-hit-1", type: "wav")
        static let gumblinHit2 = Effect(filename: "gumblin-hit-2", type: "wav")
        static let gumblinHit3 = Effect(filename: "gumblin-hit-3", type: "wav")
        static let gumblinHit4 = Effect(filename: "gumblin-hit-4", type: "wav")
        static let gumblinPress1 = Effect(filename: "gumblin-press-1", type: "wav")
        static let gumblinSelfCatapult1 = Effect(filename: "gumblin-self-catapult-1", type: "wav")
        static let gumblinSelfCatapult2 = Effect(filename: "gumblin-self-catapult-2", type: "wav")
        static let gumblinStone1 = Effect(filename: "gumblin-stone-1", type: "wav")
        static let gumblinTransform1 = Effect(filename: "gumblin-transform-1", type: "wav")
        static let gumblinTransform2 = Effect(filename: "gumblin-transform-2", type: "wav")
        static let rockEating = Effect(filename: "rock-eating", type: "wav")
        static let smallGnomeAttack = Effect(filename: "small-gnome-attack", type: "mp3")
        static let stoneblinBurn1 = Effect(filename: "stoneblin-burn-1", type: "wav")
        static let stoneblinCandy1 = Effect(filename: "stoneblin-candy-1", type: "wav")
        static let stoneblinCandy2 = Effect(filename: "stoneblin-candy-2", type: "wav")
        static let stoneblinDeath1 = Effect(filename: "stoneblin-death-1", type: "wav")
        static let stoneblinDeath2 = Effect(filename: "stoneblin-death-2", type: "wav")
        static let stoneblinDeath3 = Effect(filename: "stoneblin-death-3", type: "wav")
        static let stoneblinFear1 = Effect(filename: "stoneblin-fear-1", type: "wav")
        static let stoneblinFly1 = Effect(filename: "stoneblin-fly-1", type: "wav")
        static let stoneblinFly2 = Effect(filename: "stoneblin-fly-2", type: "wav")
        static let stoneblinFrenzy1 = Effect(filename: "stoneblin-frenzy-1", type: "wav")
        static let stoneblinFrenzy2 = Effect(filename: "stoneblin-frenzy-2", type: "wav")
        static let stoneblinFrenzy3 = Effect(filename: "stoneblin-frenzy-3", type: "wav")
        static let stoneblinGraduation1 = Effect(filename: "stoneblin-graduation-1", type: "wav")
        static let stoneblinGraduation2 = Effect(filename: "stoneblin-graduation-2", type: "wav")
        static let stoneblinHit1 = Effect(filename: "stoneblin-hit-1", type: "wav")
        static let stoneblinHit2 = Effect(filename: "stoneblin-hit-2", type: "wav")
        static let stoneblinHit3 = Effect(filename: "stoneblin-hit-3", type: "wav")
        static let stoneblinPress1 = Effect(filename: "stoneblin-press-1", type: "wav")
        static let stoneblinPress2 = Effect(filename: "stoneblin-press-2", type: "wav")
        static let stoneblinSelfCatapult1 = Effect(filename: "stoneblin-self-catapult-1", type: "wav")
        static let stoneblinSelfCatapult2 = Effect(filename: "stoneblin-self-catapult-2", type: "wav")
        static let stoneblinTransform1 = Effect(filename: "stoneblin-transform-1", type: "wav")
        static let stoneblinTransform2 = Effect(filename: "stoneblin-transform-2", type: "wav")
        static let trap = Effect(filename: "trap", type: "mp3")
        static let treeOnFire = Effect(filename: "tree-on-fire", type: "wav")

    }
}


