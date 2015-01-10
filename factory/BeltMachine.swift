//
//  BeltMachine.swift
//  factory
//
//  Created by Zach Jaquish on 1/8/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit

// Describes things that can go on a belt
class BeltMachine: Machine {
   
    // return the zone where the machine interfaces with the belt
    func baseZone() -> Zone {
        fatalError("Override me")
    }
}
