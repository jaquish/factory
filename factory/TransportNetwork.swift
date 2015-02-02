//
//  TransportNetwork.swift
//  factory
//
//  Created by Zach Jaquish on 2/1/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit

class TransportNetwork: Machine {
    
    private enum ZoneType {
        case Entrance
        case MoveTo(TransportZone)
        case Exit
    }
    
    private struct TransportZone {
        let zone: Zone
        var next: TransportZone!
        var neighbors: [TransportZone]
        
        init(zone: Zone) {
            self.zone = zone
            next = nil
            neighbors = []
        }
    }
    
    init(zones:[Zone]) {
        
        // Add all zones to list
        var neighbors:[Zone:[Zone]]
        var zoneType:[Zone:ZoneType]
        var next:[
        
        // For each zone, connect to neighbors
        for zone in self.zones {
            let zoneB = zone.zone.zone(.N)
            if contains(self.zones.map {$0.zone}, zoneB) {
                println("ZZZ")
            }
            neighbors[zone]
        }
        
        // Find all the zones with 1 neighbor
        
        // Set flow zone, verify flow is ok (error?) move up
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
