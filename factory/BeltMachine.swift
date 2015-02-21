//
//  BeltMachine.swift
//  factory
//
//  Created by Zach Jaquish on 1/8/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit

enum BeltMachineState {
    case Open
    case WaitingFor
    case Processing
}

// Describes things that can go on a belt, that take up 1 zone.
class BeltMachine: Machine {
   
    var belt: Belt!
    var beltMachineState: BeltMachineState = .Open
    
    // return the zone where the machine interfaces with the belt
    func baseZone() -> Zone {
        fatalError("Override me")
    }
    
    func waitPointForEntrance() -> CGPoint {
        var point: CGPoint = CGPointZero
        if belt.direction == .E {
            point = baseZone()^(.W)
            point.x -= WidgeWidth / 2
        } else {
            point = baseZone()^(.E)
            point.x += WidgeWidth / 2
        }
        return point
    }
    
    func entranceBoundary() -> CGFloat {
        if belt.direction == .E {
            return (baseZone()^(.W) as CGPoint).x
        } else {
            return (baseZone()^(.E) as CGPoint).x
        }
    }
    
    func exitBoundary() -> CGFloat {
        if belt.direction == .W {
            return (baseZone()^(.E) as CGPoint).x
        } else {
            return (baseZone()^(.W) as CGPoint).x
        }
    }
    
    // MARK: Manage Belt Machine state s
    func willAcceptBeltInput(widge: Widge) -> Bool {
        switch beltMachineState {
        case .Open: return true
        default: return false
        }
    }
    
    func waitForBeltInput(widge: Widge) {
        beltMachineState = .WaitingFor
    }
    
    func stopWaiting() {
        beltMachineState = .Open
    }
}
