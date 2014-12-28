//
//  Gravity.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let Falling: WidgeState = "Falling"

class Gravity: Machine {
    
    let kGravityPointsPerSecond: CGFloat = 300.0    // gravity linear
    
    let endZone: Zone
    
    init(from: Zone, thru: Zone) {
        self.endZone = thru
        
        super.init(originZone: from)
        
        self.zPosition = SpriteLayerBehindWidges
        
        addInput (originZone^(.center), name: "top", startingState: "Falling")
        addOutput(originZone^(.center), name: "bottom")
    }
    
    class override func numberOfInitializerParameters() -> Int {
        return 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        
        let top = connectorWithName("top")
        let bottom = connectorWithName("bottom")

        top.dequeueWidges()
        
        for widge in widgesInState(Falling) {
            let deltaY = -kGravityPointsPerSecond * CGFloat(_dt)
            let oldPosition = widge.position
            widge.changeYBy(deltaY)
            
            if path(from: oldPosition, to: widge.position, ranOver: bottom.position) {
                // TODO: Calculate extra distance delta
                widge.changeYTo(bottom.position.x)
                bottom.insert(widge)
            }
        }
    }
}
