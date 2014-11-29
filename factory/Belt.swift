//
//  Belt.swift
//  factory
//
//  Created by Zach Jaquish on 11/5/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let kBeltSpeedPointsPerSecond: CGFloat = 100.0
private let kVerticalBeltWidth: CGFloat = 12.0

class Belt: Machine {

    let endZone: Zone
    let direction: Direction
    
    var moving: [Widge]
    
    init(from: Zone, thru: Zone, direction: Direction) {
        
        if !(direction == .E || direction == .W) {
            println("Warning: invalid direction \(direction) for belt")
            direction == .E
        }
        
        self.endZone = thru
        self.moving = Array()
        self.direction = direction

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
        
        let overEdgeZone = (direction == .E) ? endZone.zone(.E) : originZone.zone(.W)
        addOutput(ConnectionPoint(position:overEdgeZone.worldPoint(.center), name: "over-edge"))
    }
    
    class override func numberOfInitializerParameters() -> Int {
        return 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        // TODO - save leftover deltaTime to update
        let deltaX = kBeltSpeedPointsPerSecond * CGFloat(_dt) * (direction == .W ? -1.0 : 1.0)
        
        for connector in inputs() {
            moving += connector.dequeueWidges()
        }
        
        var toDelete = [Widge]()
        for widge in moving {
            let oldPosition = widge.position
            widge.changeXBy(deltaX)
            
            // check if widge passed over connection point
            for connector in outputs() {
                if path(from: oldPosition, to: widge.position, ranOver: connector.position) {
                    widge.changeXTo(connector.position.x)
                    connector.insert(widge)
                    toDelete.append(widge)
                }
            }
        }
        
        moving = moving.filter { !contains(toDelete, $0) }
    }
    
    override func allowConnectionWith(machine: Machine) -> Bool {
        return !(machine is VerticalBelt)
    }
}
