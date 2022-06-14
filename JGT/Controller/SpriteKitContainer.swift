//
//  SpriteKitContainer.swift
//  JGT
//
//  Created by Giuseppe Falso on 16/05/22.
//

import SwiftUI
import SpriteKit

struct SpriteKitContainer : UIViewRepresentable {
    @Binding var skScene: SKScene!
    
//    init(scene: SKScene) {
//        skScene = scene
//    }
    
    class Coordinator: NSObject {
        var scene: SKScene?
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.scene = self.skScene
        return coordinator
    }
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: .zero)
        view.preferredFramesPerSecond = 60
        view.showsFPS = false
        view.showsNodeCount = false
        
        //load SpriteKit Scene
        guard let aScene = context.coordinator.scene
        else {
            view.backgroundColor = UIColor.red
            return view
        }
        aScene.scaleMode = .resizeFill
        context.coordinator.scene = aScene
        return view
    }
    
    
    func updateUIView(_ view: SKView, context: Context) {
        view.presentScene(context.coordinator.scene)
    }
    
}
