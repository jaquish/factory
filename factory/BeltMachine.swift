//
//  BeltMachine.swift
//  factory
//
//  Created by Zach Jaquish on 1/8/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit

// Describes things that can go on a belt, that take up 1 zone.
class BeltMachine: Machine {
   
    // return the zone where the machine interfaces with the belt
    func baseZone() -> Zone {
        fatalError("Override me")
    }
    
    func isProcessingWidge() -> Bool {
        fatalError("Override me")
    }
    
    func waitPointOnLeft() -> CGPoint {
        return baseZone()^(.W)
    }
    
    func waitPointOnRight() -> CGPoint {
        return baseZone()^(.E)
    }
}
