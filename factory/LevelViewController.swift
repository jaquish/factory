//
//  FGViewController.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class LevelViewController: UIViewController {

    var level: Level?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let skView = self.view as SKView
        if (skView.scene == nil) {
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            let scene = LevelScene(size: skView.bounds.size)
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
            if DEBUG_SHOW_GRID {
                self.view.addSubview(GridOverlay(frame: self.view.bounds))
            }
            
            scene.loadLevel(level!)
            
            // add double-touch double-tap back to level selection screen
            let doubleTapGesture = UITapGestureRecognizer (target: self, action: "backToLevelSelector")
            doubleTapGesture.numberOfTapsRequired = 2
            doubleTapGesture.numberOfTouchesRequired = 2
            view.addGestureRecognizer(doubleTapGesture)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func backToLevelSelector() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
