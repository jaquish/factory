//
//  Input.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let WaitingToDrop: WidgeState = "WaitingToDrop"

class Input: Machine {
       
    let interval: CFTimeInterval
    var timeRemaining: CFTimeInterval
    
    init(_ originZone: Zone, interval:CFTimeInterval = 0) {
        self.interval = interval
        self.timeRemaining = interval
        super.init(originZone: originZone)
        
        addChild(Util.zoneBoxWithBorder(UIColor.grayColor(), innerColor: UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0)))
        
        let label = SKLabelNode()
        label.verticalAlignmentMode = .Center
        label.position = ZoneZero.worldPoint(.center)
        label.text = "IN"
        label.fontSize = LabelFontSize
        addChild(label)
        
        addOutput(originZone^(.center), name: "next")
        
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        generateWidge()
    }
    
    func generateWidge() {
        createWidge((scene as LevelScene).level.nextInputType(), position: originZone^(.center), state: WaitingToDrop)
    }
    
    override func update(_dt: CFTimeInterval) {
        
        if interval > 0 {
            timeRemaining -= _dt
            if timeRemaining < 0 {
                timeRemaining += interval
                generateWidge()
                if timeRemaining < 0 {
                    println("Warning: Rendering slipped too far behind.")
                }
            }
        }
        
        for widge in widgesInState(WaitingToDrop) {
            connectors["next"]!.insert(widge)
        }
    }
    
    override func description() -> String {
        return "Input at \(originZone) generationInterval=\(interval)"
    }
}
