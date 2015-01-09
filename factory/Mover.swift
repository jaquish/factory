//
//  Mover.swift
//  factory
//
//  Created by Zach Jaquish on 12/30/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import Foundation

enum MoverStateAtZone {
    case Start, End, Thru
}

// Using a subclass for now since must use @objc flag for protocol adherence testing,
// and these methods use swift structs which are not obj-c compatible

class Mover: Machine {

    func movingDirection() -> Direction {
        fatalError("Override me")
    }
    
    func stateAtZone(zone: Zone) -> MoverStateAtZone {
        fatalError("Override me")
    }
}
