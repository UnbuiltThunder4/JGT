//
//  AudioPlayer.swift
//  JGT
//
//  Created by Luigi Luca Coletta on 05/06/22.
//

import AVKit
import SpriteKit

class AudioPlayerImpl {
    
    private var currentMusicPlayer: AVAudioPlayer?
    private var currentEffectPlayer: AVAudioPlayer?
    var musicVolume: Float = 1.0 {
        didSet { currentMusicPlayer?.volume = musicVolume }
    }
    var effectsVolume: Float = 1.0
}

extension AudioPlayerImpl: AudioPlayer {
    
    func play(music: Music) {
        currentMusicPlayer?.stop()
        guard let newPlayer = try? AVAudioPlayer(soundFile: music) else { return }
        newPlayer.volume = musicVolume
        newPlayer.prepareToPlay()
        newPlayer.play()
        newPlayer.numberOfLoops = -1
        currentMusicPlayer = newPlayer
    }
    
    func pause(music: Music) {
        currentMusicPlayer?.pause()
    }
    
    func resume() {
        currentMusicPlayer?.play()
    }
    
    func play(effect: Effect) {
        guard let effectPlayer = try? AVAudioPlayer(soundFile: effect) else { return }

        effectPlayer.volume = effectsVolume
    
        effectPlayer.play()
        currentEffectPlayer = effectPlayer
    }
}
