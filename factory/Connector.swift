//
//  Connector.swift
//  factory
//
//  Created by Zach Jaquish on 8/23/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

@objc class Connector : NSObject {
    
    var position: CGPoint = CGPointZero
    var source: Machine
    var destination: Machine
    
    private var sourceList: [Widge]
    private var destinationList: [Widge]
    
    init(position: CGPoint, source: Machine, destination: Machine) {
        self.position = position
        self.source = source
        self.destination = destination
        self.sourceList = []
        self.destinationList = []
    }
    
    func insert(widge: Widge) {
        assert(CGPointEqualToPoint(widge.position, self.position), "Widget position was not set correctly before inserting into output connector!");
        self.sourceList.append(widge)
    }
    
    func propogate() {
        for widge in reverse(self.sourceList) {
            self.destinationList.insert(widge, atIndex:0)
        }
        self.sourceList.removeAll()
    }
    
    func dequeueWidges() -> [Widge] {
        var copy = (self.destinationList as NSArray).mutableCopy() as [Widge]
        self.destinationList.removeAll()
        return copy
    }
    
    func description() -> String {
        return "Connector from " + self.source.name! + " to " + self.destination.name! + " at " + "\(position)"
    }
}