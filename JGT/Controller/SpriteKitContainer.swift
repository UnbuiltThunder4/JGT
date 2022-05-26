//
//  SpriteKitContainer.swift
//  JGT
//
//  Created by Giuseppe Falso on 16/05/22.
//

import SwiftUI
import SpriteKit

struct SpriteKitContainer : UIViewRepresentable {    
    class Coordinator: NSObject {
        var scene: TossScene? = TossScene()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
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
