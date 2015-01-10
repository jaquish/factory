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

let GravityPointsPerSecond: CGFloat = 300.0    // gravity linear

class Gravity: Mover {
    
    let direction = Direction.S
    
    let endZone: Zone
    
    init!(from: Zone, thru: Zone) {
        self.endZone = thru
        
        super.init(originZone: from)
        
        if from.x > thru.x || thru.y < from.y {
            ErrorMessageReason = "zoning should progress from lower-left to upper-right"
            return nil
        }
        
        self.zPosition = SpriteLayerBehindWidges
        
        addInput(endZone^(.center), name: "top", startingState: "Falling")
        addOutput(originZone^(.center), name: "bottom")
    }
    
    class override func numberOfInitializerParameters() -> Int {
        return 2
    }

    required override init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        
        let top = connector("top")
        let bottom = connector("bottom")

        top.dequeueWidges()
        
        for widge in widgesInState(Falling) {
            let deltaY = -GravityPointsPerSecond * CGFloat(_dt)
            let oldPosition = widge.position
            widge.changeYBy(deltaY)
            
            if path(from: oldPosition, to: widge.position, ranOver: bottom.position) {
                // TODO: Calculate extra distance delta
                widge.changeYTo(bottom.position.y)
                bottom.insert(widge)
            }
        }
    }
    
    override func description() -> String {
        return "Gravity falling \(originZone) thru \(endZone)"
    }
    
    override func movingDirection() -> Direction {
        return .S
    }
    
    override func stateAtZone(zone: Zone) -> MoverStateAtZone {
        if zone == originZone {
            return .End
        } else if zone == endZone {
            return .Start
        } else {
            // TODO: verify?
            return .Thru
        }
    }
}
