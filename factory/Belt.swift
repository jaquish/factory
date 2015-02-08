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
private let Waiting: WidgeState = "Waiting"

class Belt: Mover {

    let thruZone: Zone!
    let direction: Direction
    
    var firstZone: Zone    { return (direction == Direction.E) ? originZone : thruZone }
    var overEdgeZone: Zone { return (direction == Direction.E) ? thruZone.zone(.E) : originZone.zone(.W) }
    
    init!(from: Zone, thru: Zone, direction: Direction) {
        
        self.direction = direction
        super.init(originZone: from)
        
        // Validation
        if !(direction == .E || direction == .W) {
            ErrorMessageReason = "invalid direction \(direction.rawValue) for belt"
            return nil
        }
        
        if from.x > thru.x || thru.y < from.y {
            ErrorMessageReason = "zoning should progress from lower-left to upper-right"
            return nil
        }
        
        self.thruZone = thru
        
        self.zPosition = SpriteLayerBehindWidges
        
        let spriteNode = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(ZoneWidth * CGFloat(thruZone.x - originZone.x + 1), HorizontalBeltHeight))
        spriteNode.anchorPoint = CGPointZero
        addChild(spriteNode)
        
        for zone in ZoneSequence(originZone, thruZone) {
            var animation = SKAction.animateWithTextures([
                SKTexture(imageNamed: "moving-belt-1"),
                SKTexture(imageNamed: "moving-belt-2"),
                SKTexture(imageNamed: "moving-belt-3"),
                SKTexture(imageNamed: "moving-belt-4"),
                SKTexture(imageNamed: "moving-belt-5"),
                SKTexture(imageNamed: "moving-belt-6"),
                SKTexture(imageNamed: "moving-belt-7"),
                SKTexture(imageNamed: "moving-belt-8")
                ], timePerFrame: 0.04)
            
            if direction == .W {
                animation = animation.reversedAction()
            }
            
            let run = SKAction.repeatActionForever(animation)
            
            let tile = SKSpriteNode()
            tile.size = CGSize(width: ZoneWidth, height: HorizontalBeltHeight)
            tile.anchorPoint = CGPointZero
            tile.position = Zone(zone.x - originZone.x, 0)^(.SW)
            tile.runAction(run, withKey: "run")
            addChild(tile)
        }
    }
    
    class override func numberOfInitializerParameters() -> Int {
        return 2
    }

    required override init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addConnectionPoints() {
        for zone in ZoneSequence(originZone, thruZone) {
            addInput(zone^(.center), name: "input-\(zone.x)", startingState: Moving, priority:PriorityLevelLow)
            addOutput(zone^(.center), name: "output-\(zone.x)", priority: PriorityLevelLow)
        }
        
        addOutput(overEdgeZone^(.center), name: "over-edge")
    }
    
    override func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        return !(machine is VerticalBelt)
    }
    
    override func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        if outputPoint.name == "over-edge" {
            return machine is Gravity
        } else {
            return (machine is SwitchBox || machine is TransferBox || machine is BeltMachine || machine is Transformer || machine is Output)
        }
    }
    
    override func validateConnections() -> Bool {
        return true
        // If there is an input, there should be an output
    }
    
    // MARK: Gameplay Phase
    
    override func update(_dt: CFTimeInterval) {
        
        // Lot of assumptions here.... make sure holds for reasonable _dt
        
        // TODO - save leftover deltaTime to update
        
        let deltaX = BeltSpeedPointsPerSecond * CGFloat(_dt) * (direction == .W ? -1.0 : 1.0)
        
        dequeueAllWidges()
        
        for widge in widgesInState(Waiting) {
            // find the machine it's waiting on
            for connector in (outputs().filter{ $0.destination is BeltMachine }) {
                
                
                let beltMachine = connector.destination as BeltMachine
                let target = (direction == .E) ? beltMachine.waitPointOnLeft()
                    : beltMachine.waitPointOnRight()
                
                if widge.position == target {
                    // found the machine it was waiting for
                    if beltMachine.isProcessingWidge() {
                        widge.state = Moving // back to moving
                    }
                }
            }
        }
        
        for widge in widgesInState(Moving) {
            let oldPosition = widge.position
            widge.changeXBy(deltaX)
            
            // check if widge passed over wait point.
            // If BeltMachine is ready to accept a new widge, continue.
            // Else, hold at wait point outside of machine. (todo: jiggle animation)
            // associate wait point with machine?
            for connector in (outputs().filter{ $0.destination is BeltMachine }) {
                
                let beltMachine = connector.destination as BeltMachine
                let target = (direction == .E) ? beltMachine.waitPointOnLeft()
                                               : beltMachine.waitPointOnRight()
                
                if path(from: oldPosition, to: widge.position, ranOver: target) {
                    if beltMachine.isProcessingWidge() {
                        widge.position = target
                        widge.state = Waiting
                    }
                }
            }
            
            // Check state again, in case it was waiting
            if widge.state == Moving {
                // check if widge passed over connection point
                for connector in outputs() {
                    if path(from: oldPosition, to: widge.position, ranOver: connector.position) {
                        // TODO: Calculate extra distance delta
                        widge.changeXTo(connector.position.x)
                        connector.insert(widge)
                        break
                    }
                }
            }
        }
        
        garbagify(widgesInState(Moving))
    }
    
    // MARK: Debug
    
    override func description() -> String {
        return "Belt from \(originZone) thru \(thruZone) moving \(direction.rawValue)"
    }
    
    // MARK: Mover
    
    override func movingDirection() -> Direction {
        return self.direction
    }
    
    override func stateAtZone(zone: Zone) -> MoverStateAtZone {
        if zone == firstZone {
            return .Start
        } else if zone == overEdgeZone {
            return .End
        } else {
            // TODO: verify?
            return .Thru
        }
    }
}
