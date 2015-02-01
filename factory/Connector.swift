//
//  Connector.swift
//  factory
//
//  Created by Zach Jaquish on 8/23/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

// Widge States
let Enqueued:   WidgeState = "Enqueued"
let Propogated: WidgeState = "Propogated"

@objc class Connector : NSObject, Printable {
    
    var level: Level { return source.level }
    let position: CGPoint
    let source: Machine
    let destination: Machine
    var destinationState: WidgeState
    
    class func connect(#from: ConnectionPointOutOfMachine, to: ConnectionPointIntoMachine) {
        assert(CGPointEqualToPoint(from.position, to.position) , "Connection points must be at same point")
        assert(from.machine != to.machine , "Connection points must be on different machines")
        
        let connector = Connector(position: from.position, source:from.machine, destination:to.machine, destinationState:to.destinationState)
        
        // point both connection points to single connector
        from.connector = connector
        to.connector   = connector
    }
    
    init(position: CGPoint, source: Machine, destination: Machine, destinationState: WidgeState) {
        self.position = position
        self.source = source
        self.destination = destination
        self.destinationState = destinationState
    }
    
    func insert(widge: Widge) {
        assert(CGPointEqualToPoint(widge.position, self.position), "Widget position was not set correctly before inserting into output connector!");
        widge.owner = self
        widge.state = Enqueued
    }
    
    func propogate() {
        for widge in widges() {
            if widge.state != Enqueued {
                fatalError("Widge \(widge) was not in dequeued state before propogation")
            }
            widge.state = Propogated
        }
    }
    
    func dequeueWidges() -> [Widge] {
        let dequeued = widges()
        var count = 0
        for widge in dequeued {
            widge.owner = destination
            widge.state = destinationState
            count++
        }
        
        return dequeued
    }
    
    func dequeueWidge() -> Widge? {
        let widges = dequeueWidges()
        assert(widges.count <= 1, "Expected only 1 widge")
        return widges.first
    }
    
    func widges() -> [Widge] {
        return level.widges.filter { ($0.owner as? Connector) == self }
    }
    
    // MARK: Debug
    
    func description() -> String {
        return self.source.name! + " to " + self.destination.name! + " at " + "\(Zone(containing:position))"
    }
}