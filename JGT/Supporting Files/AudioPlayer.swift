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
    var node: SKNode?
}

extension AudioPlayerImpl: AudioPlayer {
    
    
    func play(music: Music) {
        currentMusicPlayer?.stop()
        guard let newPlayer = try? AVAudioPlayer(soundFile: music) else { return }
        newPlayer.volume = musicVolume
        newPlayer.play()
        currentMusicPlayer = newPlayer
    }
    
    func pause(music: Music) {
        currentMusicPlayer?.pause()
    }
    
    func play(effect: Effect, node: SKNode?) {
        guard let effectPlayer = try? AVAudioPlayer(soundFile: effect) else { return }
        if let node = node {
            if (node.position.x > (node.parent?.scene?.camera?.position.x)! + UIScreen.main.bounds.width/2 ||
                node.position.y > (node.parent?.scene?.camera?.position.y)! + UIScreen.main.bounds.height/2) ||
                (node.position.x < (node.parent?.scene?.camera?.position.x)! - UIScreen.main.bounds.width/2 ||
                    node.position.y < (node.parent?.scene?.camera?.position.y)! - UIScreen.main.bounds.height/2)
            {
                print("muteq")
                effectPlayer.volume = 0.0
            }
            else {
                effectPlayer.volume = effectsVolume
            }
        }
        else {
            effectPlayer.volume = effectsVolume
        }
        effectPlayer.play()
        currentEffectPlayer = effectPlayer
    }
}
