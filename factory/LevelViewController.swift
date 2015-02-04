//
//  FGViewController.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

let OutputCountNotification = "OutputCountNotification"

class LevelViewController: UIViewController, SKSceneDelegate {

    var level: Level!
    var debugViews: [UIView] = []
    var statusBar: StatusBar!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let skView = self.view as SKView
        if (skView.scene == nil) {
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            let scene = level
            scene.size = skView.bounds.size
            scene.scaleMode = .AspectFill
            scene.delegate = self
            skView.presentScene(scene)
            
            if DEBUG_SHOW_GRID {
                let grid = GridOverlay(frame: self.view.bounds)
                self.view.addSubview(grid)
                debugViews.append(grid)
            }
            
            if DEBUG_SHOW_NUMBERS {
                let numbers = GridNumbering(frame: self.view.bounds)
                self.view.addSubview(numbers)
                debugViews.append(numbers)
            }
            
            statusBar = StatusBar()
            statusBar.levelVC = self
            view.addSubview(statusBar)
            statusBar.updateWith(0, endGameCount: level.endgame_output_count)
            
            // double-touch triple-tap back to level selection screen
            let tripleTapGesture = UITapGestureRecognizer (target: self, action: "gameOver")
            tripleTapGesture.numberOfTapsRequired = 3
            tripleTapGesture.numberOfTouchesRequired = 2
            view.addGestureRecognizer(tripleTapGesture)
            
            // double-touch double-tap back to level selection screen
            let doubleTapGesture = UITapGestureRecognizer (target: self, action: "backToLevelSelector")
            doubleTapGesture.numberOfTapsRequired = 2
            doubleTapGesture.numberOfTouchesRequired = 2
            doubleTapGesture.requireGestureRecognizerToFail(tripleTapGesture)
            view.addGestureRecognizer(doubleTapGesture)
            
            toggleDebug()
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
    
    func didFinishUpdateForScene(scene: SKScene) {
        if level!.isGameOver() {
            gameOver()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStatusBarCount", name: OutputCountNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OutputCountNotification, object: nil)
    }
    
    
    func backToLevelSelector() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func gameOver() {
        (self.view as SKView).paused = true
        self.performSegueWithIdentifier("kSegueGameOver", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "kSegueGameOver" {
            let gameoverVC = segue.destinationViewController as GameOverViewController
            gameoverVC.level = level
        }
    }
    
    func toggleDebug() {
        let hidden = debugViews[0].hidden
        debugViews.map { $0.hidden = !hidden }
        
        (view as SKView).showsFPS = hidden
        (view as SKView).showsNodeCount = hidden
    }
    
    func togglePause(sender: AnyObject) {
        let skView = view as SKView
        skView.paused = !skView.paused
    }
    
    func updateStatusBarCount() {
        statusBar.updateWith(level.outputs.count, endGameCount: level.endgame_output_count)
    }
}
