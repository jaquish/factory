//
//  VerticalBelt.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class VerticalBelt: Machine {
    
    let kBeltSpeedPointsPerSecond: CGFloat = 100.0
    let kVerticalBeltWidth: CGFloat = 30.0
    
    var moving: [Widge]
    let endZone: Zone

    init(from: Zone, thru: Zone) {
        
        self.endZone = thru
        self.moving  = Array()
        super.init(originZone: from)
        
        zPosition = SpriteLayerBehindWidges
        
        let sprite = SKSpriteNode(color: UIColor(red: 0.0, green: 0.4, blue: 0.9, alpha: 1.0), size: CGSizeMake(kVerticalBeltWidth, ZoneSize * CGFloat(endZone.y - originZone.y + 1)))
        sprite.anchorPoint = CGPointZero
        addChild(sprite)
        
        addSimpleInput("input")
        addOutput(ConnectionPoint(position:endZone.worldPoint(.center), name: "ouput"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        // TODO - save leftover deltaTime to update

        let deltaY = kBeltSpeedPointsPerSecond * CGFloat(_dt)
        
        // Fetch fresh widgets
        for connector in inputs() {
            moving += connector.dequeueWidges()
        }
        
        // Move widges, check for collision with output
        var toDelete = [Widge]()
        for widge in moving {
            let oldPosition = widge.position
            widge.changeYBy(deltaY)
        
            // check if widge passed over connection point
            for connector in outputs() {
                if oldPosition.y < connector.position.y && widge.position.y >= connector.position.y {
                    widge.changeYTo(connector.position.y)
                    connector.insert(widge)
                    toDelete.append(widge)
                }
            }
            // Gross
            moving = moving.filter { !contains(toDelete, $0) }
        }
    }
}
