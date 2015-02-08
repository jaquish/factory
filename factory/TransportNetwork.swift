//
//  TransportNetwork.swift
//  factory
//
//  Created by Zach Jaquish on 2/1/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit

enum ZoneType {
    case EntranceMoveTo(TransportZone)
    case MoveTo(TransportZone)
    case Exit
}

class TransportZone {
    let zone: Zone
    var type: ZoneType!
    var next: TransportZone!
    var neighbors: [TransportZone]
    
    init(zone: Zone) {
        self.zone = zone
        next = nil
        neighbors = []
    }
    
    func flowAllIntoSelf() {
        type = .Exit
        for n in neighbors {
            n.flowInto(self)
        }
    }
    
    func flowInto(tz: TransportZone) {
        
        next = tz
        
        if neighbors.count == 1 {
            type = .EntranceMoveTo(tz)
        } else {
            type = .MoveTo(tz)
            
            let unflowedNeighbors = neighbors.filter { $0.zone != self.next.zone }
            for n in unflowedNeighbors {
                if n.zone.y < self.zone.y {
                    println("Warning: transport network going against gravity")
                }
                n.flowInto(self)
            }
        }
    }
}

func ==(a: ZoneType, b: ZoneType) -> Bool {
    switch (a, b) {
    case (.EntranceMoveTo(let a), .EntranceMoveTo(let b))   where a == b: return true
    case (.MoveTo(let a), .MoveTo(let b)) where a == b: return true
    case (.Exit, .Exit): return true
    default: return false
    }
}

func ==(a: TransportZone, b: TransportZone) -> Bool {
    return a.zone == b.zone
}

private let InTransport: WidgeState = "InTransport"
private let TransportSpeedPerZone: CFTimeInterval = 0.25
private let UserInfoTimeInZone = "UserInfoTimeInZone"
private let UserInfoTransportZone = "UserInfoTransportZone"

class TransportNetwork: Machine {
    
    private var transportZones: [TransportZone]
    
    init(zones:[Zone]) {
        // Add all zones to list
        transportZones = zones.map { TransportZone(zone: $0) }
        
        // For each zone, connect to neighbors
        for tz in transportZones {
            let directions:[Direction] = [.N,.E,.S,.W]
            for direction in directions {
                let neighbor = tz.zone.zone(direction)
                if contains(zones, neighbor) {
                    tz.neighbors.append(transportZones.filter({$0.zone == neighbor}).first!)
                }
            }
        }
        
        // Find all the zones with 1 neighbor
        var endPoints = transportZones.filter { $0.neighbors.count == 1 }
        endPoints.sort { $0.zone.y < $1.zone.y }
        
        if endPoints.count >= 2 && endPoints[0].zone.y == endPoints[1].zone.y {
            println("Could not determine where to start, unknown result")
        }
        
        // Set flow zone, verify flow is ok (error?) move up
        let tz = endPoints.first!
        tz.flowAllIntoSelf()
        
        for tz in transportZones {
            assert(tz.type != nil, "Should have valid type")
            if tz.type == .Exit {
                assert(tz.next == nil, "next should match type")
            } else {
                assert(tz.next != nil, "next should match type")
            }
        }
        
        super.init(originZone:ZoneZero)
        
        // display
        for tz in transportZones {
            let translucentTube = Util.zoneBoxWithColor(UIColor.lightGrayColor())
            translucentTube.position = tz.zone.originPoint()
            addChild(translucentTube)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addConnectionPoints() {
        for zone in entranceZones() {
            addInput(zone.zone^(.center), name: "input-\(zone.zone.x)-\(zone.zone.y))", startingState: InTransport)
        }
        
        for zone in exitZones() {
            addOutput(zone.zone^(.center), name: "output-\(zone.zone.x)-\(zone.zone.y))")
        }
    }
    
    override func update(_dt: CFTimeInterval) {
        
        for connector in inputs() {
            let widges = connector.dequeueWidges()

            // assign to zone
            let matchingZone = transportZones.filter { $0.zone == Zone(containing:connector.position) }.first!
            
            for widge in widges {
                widge.userData = [
                        UserInfoTransportZone : matchingZone,
                        UserInfoTimeInZone : 0.0
                    ]
            }
        }
        
        for widge in widgesInState(InTransport) {
            let current = widge.userData![UserInfoTimeInZone] as CFTimeInterval
            widge.userData![UserInfoTimeInZone] = current + _dt
            
            if widge.userData![UserInfoTimeInZone] as CFTimeInterval > TransportSpeedPerZone {
                
                let tz = widge.userData![UserInfoTransportZone]! as TransportZone
                if tz.type == .Exit {
                    // exiting the transport network
                    widge.userData = nil
                    let matchingOutput = outputs().filter { tz.zone == Zone(containing:$0.position) }.first!
                    matchingOutput.insert(widge)
                } else {
                    // move to next zone
                    let current = widge.userData![UserInfoTimeInZone] as CFTimeInterval
                    widge.userData![UserInfoTimeInZone] = current - TransportSpeedPerZone
                    
                    widge.userData![UserInfoTransportZone] = tz.next
                    widge.position = tz.next.zone^(.center)
                }
            }
        }
        
        garbagify(widgesInState(InTransport))
    }
    
    private func entranceZones() -> [TransportZone] {
        return transportZones.filter {
            switch $0.type! {
            case .EntranceMoveTo(let a): return true
            default: return false
            }
        }
    }
    
    private func exitZones() -> [TransportZone] {
        return transportZones.filter {
            switch $0.type! {
            case .Exit: return true
            default: return false
            }
        }
    }
}
