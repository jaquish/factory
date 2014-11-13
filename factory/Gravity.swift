//
//  Gravity.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class Gravity: Machine {
    
    let kGravityPointsPerSecond: CGFloat = 300.0    // gravity linear
    
    var falling: [Widge]
    let endZone: Zone
    
    init(originZone: Zone, endZone: Zone) {
        self.endZone = endZone
        self.falling = Array()
        
        super.init(originZone: originZone)
        
        self.zPosition = SpriteLayerBehindWidges
        
        addInput (ConnectionPoint(position: originZone.worldPoint(.center), name: "top"))
        addOutput(ConnectionPoint(position:    endZone.worldPoint(.center), name: "bottom"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        let connector = connectors["top"]!
        falling += connector.dequeueWidges()
        
        var toDelete = [Widge]()
        for widge in falling {
            widge.changeYBy(-kGravityPointsPerSecond * CGFloat(_dt))
            
            if let bottom = connectors["bottom"] {
                if widge.position.y < bottom.position.y {
                    widge.changeYTo(bottom.position.y)
                    toDelete.append(widge)
                    bottom.insert(widge)
                }
            }
        }
        
        falling = falling.filter { !contains(toDelete, $0) }
    }
}
