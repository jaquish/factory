//
//  VerticalBelt.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let kBeltSpeedPointsPerSecond: CGFloat = 100.0
private let kVerticalBeltWidth: CGFloat = 30.0

class VerticalBelt: Machine {
    
    let direction: Direction
    var moving: [Widge]
    let endZone: Zone

    init(from: Zone, thru: Zone, direction: Direction) {
        
        if !(direction == .N || direction == .S) {
            println("Warning: invalid direction \(direction) for belt")
            direction == .N
        }
        
        self.direction = direction
        self.endZone = thru
        self.moving  = Array()
        super.init(originZone: from)
        
        zPosition = SpriteLayerBehindWidges
        
        let sprite = SKSpriteNode(color: UIColor(red: 0.0, green: 0.4, blue: 0.9, alpha: 1.0), size: CGSizeMake(kVerticalBeltWidth, ZoneSize * CGFloat(endZone.y - originZone.y + 1)))
        sprite.anchorPoint = CGPointZero
        addChild(sprite)
        
        let inputZone  = (direction == .N) ? originZone : endZone
        let outputZone = (direction == .N) ? endZone : originZone
        
        addInput(ConnectionPoint(position:inputZone.worldPoint(.center), name: "input"))
        addOutput(ConnectionPoint(position:outputZone.worldPoint(.center), name: "output"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        // TODO - save leftover deltaTime to update

        let deltaY = kBeltSpeedPointsPerSecond * CGFloat(_dt) * (direction == .S ? -1.0 : 1.0)
        
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
                if path(from: oldPosition, to: widge.position, ranOver: connector.position) {
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
