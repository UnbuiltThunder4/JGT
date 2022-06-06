//
//  Functions.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import Foundation
import SwiftUI
import AVFoundation

func weightedRandom<Value>(weightedValues: [(Value, Double)]) -> Value {
    let rnd = Double.random(in: 0.0...100.0)
    var accWeight = 0.0
    for i in (0..<weightedValues.count) {
        accWeight += weightedValues[i].1
        //print(rnd, accWeight)
        if rnd <= accWeight {
            return weightedValues[i].0
        }
    }
    
    return weightedValues[0].0
}

func getParentIndex() -> [Int] {
    var ar: [Int] = []
    var count0 = 0
    var count1 = 0
    for _ in 0..<4 {
        if (count0 >= 2) {
            ar.append(1)
        }
        else if (count1 >= 2) {
            ar.append(0)
        }
        else {
            let value = Int.random(in: 0...1)
            if (value == 0) {
                count0 += 1
            }
            else if (value == 1) {
                count1 += 1
            }
            ar.append(value)
        }
    }
    return ar
}

func isVectorSmallerThan(vector: CGVector, other: CGFloat) -> Bool {
    let magnitudeSquared = (vector.dx * vector.dx) + (vector.dy * vector.dy)
    let maxSquared = other * other
    if (magnitudeSquared <= maxSquared) {
        return true
    }
    else {
        return false
    }
}

func limitVector(vector: CGVector, max: CGFloat) -> CGVector {
    let magnitudeSquared = (vector.dx * vector.dx) + (vector.dy * vector.dy)
    let maxSquared = max * max
    if (magnitudeSquared <= maxSquared) {
        return vector
    }

    let magnitude = sqrt(magnitudeSquared)
    let normalizedX = vector.dx / magnitude
    let normalizedY = vector.dy / magnitude
    let newX = normalizedX * max
    let newY = normalizedY * max

    return CGVector(dx: newX, dy: newY)
}

func getDuration(distance: CGVector, speed: CGFloat) -> TimeInterval {
    let dist = sqrt((distance.dx * distance.dx) + (distance.dy * distance.dy))
    return TimeInterval(dist/speed)
}

//var backgroundMusicPlayer: AVAudioPlayer!
//var effectsMusicPlayer: AVAudioPlayer!
//
//func playBackgroundMusic(filename: String) {
//  let resourceUrl = Bundle.main.url(forResource:
//    filename, withExtension: nil)
//  guard let url = resourceUrl else {
//    print("Could not find file: \(filename)")
//return
//}
//  do {
//    try backgroundMusicPlayer =
//      AVAudioPlayer(contentsOf: url)
//          backgroundMusicPlayer.numberOfLoops = -1
//          backgroundMusicPlayer.prepareToPlay()
//          backgroundMusicPlayer.play()
//        } catch {
//          print("Could not create audio player!")
//      return
//        }
//}

