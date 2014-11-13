//
//  Belt.swift
//  factory
//
//  Created by Zach Jaquish on 11/5/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class Belt: Machine {
   
    let kBeltSpeedPointsPerSecond: CGFloat = 100.0
    let kVerticalBeltWidth: CGFloat = 12.0
    
    let endZone: Zone
    
    var moving: [Widge]
    
    init(from: Zone, thru: Zone) {
        self.endZone = thru
        self.moving = Array()

        super.init(originZone: from)
        
        self.zPosition = SpriteLayerBehindWidges
        
        let spriteNode = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(ZoneSize * CGFloat(endZone.x - originZone.x + 1), kVerticalBeltWidth))
        spriteNode.anchorPoint = CGPointZero
        addChild(spriteNode)
        
        for i in stride(from: self.originZone.x, through: self.endZone.x, by: 1) {
            let p = Zone(i, originZone.y).worldPoint(.center)
            addInput (ConnectionPoint(position: p, name:  "input-\(i)"))
            addOutput(ConnectionPoint(position: p, name: "output-\(i)"))
        }
        
        addOutput(ConnectionPoint(position:endZone.zone(.E).worldPoint(.center), name: "over-right-edge"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        // TODO - save leftover deltaTime to update
        let deltaX = kBeltSpeedPointsPerSecond * CGFloat(_dt)
        
        for connector in inputs() {
            moving += connector.dequeueWidges()
        }
        
        var toDelete = [Widge]()
        for widge in moving {
            let oldPosition = widge.position
            widge.changeXBy(deltaX)
            
            // check if widge passed over connection point
            for connector in outputs() {
                if oldPosition.x < connector.position.x && widge.position.x >= connector.position.x {
                    widge.changeXTo(connector.position.x)
                    connector.insert(widge)
                    toDelete.append(widge)
                }
            }
        }
        
        moving = moving.filter { !contains(toDelete, $0) }
    }
}
