//
//  Belt.swift
//  factory
//
//  Created by Zach Jaquish on 11/5/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let BeltSpeedPointsPerSecond: CGFloat = 100.0
private let HorizontalBeltHeight: CGFloat = 12.0

private let Moving: WidgeState = "Moving"

class Belt: Machine {

    let thruZone: Zone!
    let direction: Direction!
    
    var lastZone: Zone     { return (direction == Direction.E) ? thruZone : originZone }
    var overEdgeZone: Zone { return (direction == .E) ? thruZone.zone(.E) : originZone.zone(.W) }
    
    init!(from: Zone, thru: Zone, direction: Direction) {
        
        super.init(originZone: from)
        
        // Validation
        if !(direction == .E || direction == .W) {
            println("Error: invalid direction \(direction) for belt")
            return nil
        }
        
        if from.x > thru.x || thru.y < from.y {
            println("Error: zoning should progress from lower-left to upper-right")
            return nil
        }
        
        self.thruZone = thru
        self.direction = direction
        
        self.zPosition = SpriteLayerBehindWidges
        
        let spriteNode = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(ZoneSize * CGFloat(thruZone.x - originZone.x + 1), HorizontalBeltHeight))
        spriteNode.anchorPoint = CGPointZero
        addChild(spriteNode)
        
        for zone in ZoneSequence(originZone, thruZone) {
            addInput(zone^(.center), name: "input-\(zone.x)", startingState: Moving, isRequired: false)
            addOutput(zone^(.center), name: "output-\(zone.x)", isRequired: false)
        }
        
        addOutput(overEdgeZone^(.center), name: "over-edge")
    }
    
    class override func numberOfInitializerParameters() -> Int {
        return 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        return !(machine is VerticalBelt)
    }
    
    override func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        return !(machine is VerticalBelt)
    }
    
    override func update(_dt: CFTimeInterval) {
        
        // TODO - save leftover deltaTime to update
        
        let deltaX = BeltSpeedPointsPerSecond * CGFloat(_dt) * (direction == .W ? -1.0 : 1.0)
        
        dequeueAllWidges()
        
        for widge in widgesInState(Moving) {
            let oldPosition = widge.position
            widge.changeXBy(deltaX)
            
            // check if widge passed over connection point
            for connector in outputs() {
                if path(from: oldPosition, to: widge.position, ranOver: connector.position) {
                    // TODO: Calculate extra distance delta
                    widge.changeXTo(connector.position.x)
                    connector.insert(widge)
                }
            }
        }
//        
//        var newGarbage = [Widge]()
//        
//        // Check for overlap, delete if necessary
//        // TODO: much smarter garbage logic
//        for widge1 in widgesInState(Moving) {
//            for widge2 in widgesInState(Moving) {
//                if widge1 != widge2 && CGRectIntersectsRect(widge1.frame, widge2.frame) {
//                    
//                    // don't consider the same pair twice
//                    if !(contains(toDelete, widge1) && contains(toDelete, widge2)) {
//                        let garbageReplacement = Widge.garbage()
//                        garbageReplacement.position = widge1.position
//                        newGarbage.append(garbageReplacement)
//                        
//                        if !contains(toDelete, widge1) {
//                            toDelete.append(widge1)
//                        }
//                        if !contains(toDelete, widge2) {
//                            toDelete.append(widge2)
//                        }
//                    }
//                }
//            }
//        }
//        
//        removeWidges(toDelete)
//        
//        for widge in toDelete {
//            widge.removeFromParent()
//        }
//        
//        for widge in newGarbage {
//            scene!.addChild(widge)
//            addWidge(widge, startingState: Moving)
//        }
    }
}
