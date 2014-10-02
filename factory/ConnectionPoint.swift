//
//  ConnectionPoint.swift
//  factory
//
//  Created by Zach Jaquish on 10/11/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

@objc class ConnectionPoint {
    
    var position:CGPoint
    var connector:Connector?
    var machine:Machine?
    var name:NSString
    var priority = 0

    init(position:CGPoint, name:NSString) {
        self.position = position
        self.name = name
    }
    
    class func pointWithPosition(position:CGPoint, name:NSString) -> ConnectionPoint {
        return ConnectionPoint(position: position, name: name)
    }
    
    func tryToConnectToPoint(otherPoint:ConnectionPoint) {
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
        
        // don't connect if machines are not setup yet
        if machine == nil || otherPoint.machine == nil {
            return;
        }
        
        /* Ask the machines involved for advanced connection point rules */

        if machine!.allowConnectionWith(otherPoint.machine!) &&
            otherPoint.machine!.allowConnectionWith(machine!) {
                
            // create new connector and set
            let connector = Connector(position: self.position, source:machine!, destination: otherPoint.machine!)
                
            // point both connection points to single connector
            self.connector = connector;
            otherPoint.connector = connector;
                
            println("Connected \(self.machine!.name!) \(self.name) to \(otherPoint.machine!.name!) \(otherPoint.name)")
        }
    }
    
    func description() -> String {
        return "\(self.machine!.name!) \(self.name)"
    }
}
