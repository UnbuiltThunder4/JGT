//
//  MainScreenView.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import SwiftUI
import UIKit

/**
 * # MainScreenView
 *
 *   This view is responsible for presenting the game name, the game intructions and to start the game.
 *  - Customize it as much as you want.
 *  - Experiment with colors and effects on the interface
 *  - Adapt the "Insert a Coin Button" to the visual identity of your game
 **/

struct LevelSelectionView: View {
    
    // The game state is used to transition between the different states of the game
    @Binding var currentGameState: GameState
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    // Change it on the Constants.swift file
    var gameTitle: String = MainScreenProperties.gameTitle
    
    // Change it on the Constants.swift file
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    // Change it on the Constants.swift file
    let accentColor: Color = MainScreenProperties.accentColor
    
    @State var isPressed: Bool = false
    @State var isPressedFX: Bool = false
    @State var index: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                
                
            
                Spacer()

                
                HStack {
                    
                Button {
                    withAnimation { self.startGame() }
                } label: {
                    Text("Play")
                        .font(.custom("Chalkduster", size: (UIDevice.current.userInterfaceIdiom == .pad ? 30 : 15)))
                    
                }
                .frame(maxWidth: geometry.size.width * 0.1, maxHeight: geometry.size.height * 0.1)
                .padding(5)
                .foregroundColor(.white)
                .background(self.accentColor)
                .cornerRadius(15.0)
                    
                }
                
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            .statusBar(hidden: true)
        }
    }
    
    /**
     * Function responsible to start the game.
     * It changes the current game state to present the view which houses the game scene.
     */
    private func startGame() {
        print("- Starting the game...")
        gameLogic.gameState = .playing
    }
}





//class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    var pageController: UIPageViewController!
//    var controllers = [UIViewController]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
//        pageController.dataSource = self
//        pageController.delegate = self
//
//        addChild(pageController)
//        view.addSubview(pageController.view)
//
//        let views = ["pageController": pageController.view] as [String: AnyObject]
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
//
//        for _ in 1 ... 5 {
//            let vc = UIViewController()
//            vc.view.backgroundColor = randomColor()
//            controllers.append(vc)
//        }
//
//        pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        if let index = controllers.firstIndex(of: viewController) {
//            if index > 0 {
//                return controllers[index - 1]
//            } else {
//                return nil
//            }
//        }
//
//        return nil
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if let index = controllers.firstIndex(of: viewController) {
//            if index < controllers.count - 1 {
//                return controllers[index + 1]
//            } else {
//                return nil
//            }
//        }
//
//        return nil
//    }
//
//    func randomCGFloat() -> CGFloat {
//        return CGFloat(arc4random()) / CGFloat(UInt32.max)
//    }
//
//    func randomColor() -> UIColor {
//        return UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1)
//    }
//}

struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectionView(currentGameState: .constant(GameState.mainScreen))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

