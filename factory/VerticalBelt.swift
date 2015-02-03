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

class VerticalBelt: Mover {
    
    let direction: Direction
    let thruZone: Zone
    var firstZone: Zone { return (direction == Direction.N) ? originZone :   thruZone }
    var lastZone: Zone  { return (direction == Direction.N) ? thruZone   : originZone }

    init(from: Zone, thru: Zone, direction: Direction) {
        
        if !(direction == .N || direction == .S) {
            println("Warning: invalid direction \(direction.rawValue) for belt")
            direction == .N
        }
        
        self.direction = direction
        self.thruZone = thru
        super.init(originZone: from)
        
        zPosition = SpriteLayerBehindWidges
        
        let sprite = SKSpriteNode(color: UIColor(red: 0.0, green: 0.4, blue: 0.9, alpha: 1.0), size: CGSizeMake(kVerticalBeltWidth, ZoneHeight * CGFloat(thruZone.y - originZone.y + 1)))
        sprite.anchorPoint = CGPointZero
        addChild(sprite)
    }

    required override init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addConnectionPoints() {
        let inputZone  = (direction == .N) ? originZone : thruZone
        let outputZone = (direction == .N) ? thruZone : originZone
        
        addInput(inputZone^(.center), name:"input", startingState: Moving)
        addOutput(outputZone^(.center), name:"output")
    }
        
    override func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        return (machine is TransferBox) || (machine is SwitchBox) || (machine is Input)
    }
    
    override func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        return (machine is TransferBox) || (machine is SwitchBox) || (machine is Output)
    }
    
    // MARK: Gameplay Phase
    
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
    
    // MARK: Mover
    
    override func movingDirection() -> Direction {
        return self.direction
    }
    
    override func stateAtZone(zone: Zone) -> MoverStateAtZone {
        if zone == firstZone {
            return .Start
        } else if zone == lastZone {
            return .End
        } else {
            // TODO: verify?
            return .Thru
        }
    }
    
    // MARK: Debug
    
    override func description() -> String {
        return "VerticalBelt from \(originZone) thru \(thruZone) moving \(direction.rawValue)"
    }
}
