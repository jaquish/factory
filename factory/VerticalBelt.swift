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

private let Moving: WidgeState = "Moving"

class VerticalBelt: Machine {
    
    let direction: Direction
    let endZone: Zone
    var lastZone: Zone { return (direction == .N) ? originZone : endZone }

    init(from: Zone, thru: Zone, direction: Direction) {
        
        if !(direction == .N || direction == .S) {
            println("Warning: invalid direction \(direction) for belt")
            direction == .N
        }
        
        self.direction = direction
        self.endZone = thru
        super.init(originZone: from)
        
        zPosition = SpriteLayerBehindWidges
        
        let sprite = SKSpriteNode(color: UIColor(red: 0.0, green: 0.4, blue: 0.9, alpha: 1.0), size: CGSizeMake(kVerticalBeltWidth, ZoneSize * CGFloat(endZone.y - originZone.y + 1)))
        sprite.anchorPoint = CGPointZero
        addChild(sprite)
        
        let inputZone  = (direction == .N) ? originZone : endZone
        let outputZone = (direction == .N) ? endZone : originZone
        
        addInput(inputZone^(.center), name:"input", startingState: Moving)
        addOutput(outputZone^(.center), name:"output")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        return (machine is TransferBox) || (machine is SwitchBox) || (machine is Input)
    }
    
    override func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        return (machine is TransferBox) || (machine is SwitchBox) || (machine is Output)
    }
    
    override func update(_dt: CFTimeInterval) {
        // TODO - save leftover deltaTime to update

        let deltaY = kBeltSpeedPointsPerSecond * CGFloat(_dt) * (direction == .S ? -1.0 : 1.0)
        
        dequeueAllWidges()
        
        for widge in widgesInState(Moving) {
            let oldPosition = widge.position
            widge.changeYBy(deltaY)
            
            let output = connector("output")
            
            // check if widge passed over connection point
            if path(from: oldPosition, to: widge.position, ranOver: output.position) {
                // TODO: Calculate extra distance delta
                widge.changeYTo(output.position.y)
                output.insert(widge)
            }
        }
    }
    
    override func description() -> String {
        return "VerticalBelt from \(originZone) thru \(endZone) moving \(direction)"
    }
}
