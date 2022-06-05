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
        static let perl = Effect(filename: "perl", type: "wav")
    }
}


