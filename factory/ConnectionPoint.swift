//
//  ConnectionPoint.swift
//  factory
//
//  Created by Zach Jaquish on 10/11/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

class ConnectionPoint {
    
    var position:CGPoint
    var connector:Connector?
    var machine:Machine
    var name:NSString
    var priority: Int
    var isRequired: Bool

    init(machine: Machine, position:CGPoint, name:NSString, priority:Int = 0, isRequired: Bool = true) {
        assert(name.length > 0, "Connection point should have a name.")
        self.machine = machine
        self.position = position
        self.name = name
        self.priority = priority
        self.isRequired = isRequired
    }
    
    // TODO
//    func description() -> String {
//        return "\(self.machine.name!) \(self.name)"
//    }
}

class ConnectionPointDestination : ConnectionPoint {
    var destinationState: WidgeState

    init(machine: Machine, position: CGPoint, name: NSString, destinationState: WidgeState, priority:Int = 0, isRequired: Bool = true) {
        self.destinationState = destinationState
        super.init(machine: machine, position: position, name: name, priority: priority, isRequired: isRequired)
    }
}

class ConnectionPointSource : ConnectionPoint {
    func tryToConnectToPoint(otherPoint:ConnectionPointDestination) {
        /* Basic connection point rules */
        
        // don't connect a connection point that has already been connected
        if connector != nil || otherPoint.connector != nil {
            return;
        }
        
        // don't connect a machine to itself
        if machine == otherPoint.machine {
            return;
        }
        
        // don't connect if connection points are not in the same position
        if (!CGPointEqualToPoint(position, otherPoint.position)) {
            return;
        }
        
        /* Ask the machines involved for advanced connection point rules */
        let allowedByThisMachine = machine.allow(outputPoint: self, toConnectToMachine: otherPoint.machine)
        let allowedByOtherMachine = otherPoint.machine.allow(inputPoint: otherPoint, toConnectFromMachine: self.machine)
        
        if allowedByThisMachine && allowedByOtherMachine {
            
            // create new connector and set
            Connector.connect(from: self, to: otherPoint)
        }
    }
}
