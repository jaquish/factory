//
//  Zone.swift
//  factory
//
//  Created by Zach Jaquish on 11/12/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import Foundation
import UIKit

struct Zone : Printable, Hashable, Equatable {
    var x: Int
    var y: Int
    
    // shortcut initializer
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    init(containing:CGPoint) {
        x = Int(containing.x) / Int(ZoneWidth)
        y = Int(containing.y) / Int(ZoneHeight)
    }
    
    init(_ string: String) {
        let pieces = string.componentsSeparatedByString(",") as [String]
        assert(pieces.count == 2, "expected two pieces from string for Zone")
        x = pieces[0].toInt()!
        y = pieces[1].toInt()!
    }
    
    func worldPoint(cp: Direction) -> CGPoint {
        switch (cp) {
            case .N:     return CGPointMake(ZoneWidth * (CGFloat(x) + 0.5), ZoneHeight * (CGFloat(y) + 1.0));
            case .NE:    return CGPointMake(ZoneWidth * (CGFloat(x) + 1.0), ZoneHeight * (CGFloat(y) + 1.0));
            case .E:     return CGPointMake(ZoneWidth * (CGFloat(x) + 1.0), ZoneHeight * (CGFloat(y) + 0.5));
            case .SE:    return CGPointMake(ZoneWidth * (CGFloat(x) + 1.0), ZoneHeight * (CGFloat(y)      ));
            case .S:     return CGPointMake(ZoneWidth * (CGFloat(x) + 0.5), ZoneHeight * (CGFloat(y)      ));
            case .SW:    return CGPointMake(ZoneWidth * (CGFloat(x)      ), ZoneHeight * (CGFloat(y)      ));
            case .W:     return CGPointMake(ZoneWidth * (CGFloat(x)      ), ZoneHeight * (CGFloat(y) + 0.5));
            case .NW:    return CGPointMake(ZoneWidth * (CGFloat(x)      ), ZoneHeight * (CGFloat(y) + 1.0));
            case .center:return CGPointMake(ZoneWidth * (CGFloat(x) + 0.5), ZoneHeight * (CGFloat(y) + 0.5));
        }
    }
    
    func originPoint() -> CGPoint {
        return worldPoint(.SW)
    }
    
    func zone(cp: Direction) -> Zone {
        switch (cp) {
            case .N:     return Zone(x    , y + 1)
            case .NE:    return Zone(x + 1, y + 1)
            case .E:     return Zone(x + 1, y    )
            case .SE:    return Zone(x + 1, y - 1)
            case .S:     return Zone(x    , y - 1)
            case .SW:    return Zone(x - 1, y - 1)
            case .W:     return Zone(x - 1, y    )
            case .NW:    return Zone(x - 1, y + 1)
            case .center:return self;
        }
    }
    
    func toString() -> String {
        return "\(x),\(y)"
    }
    
    // Printable
    var description: String {
        get { return "(\(x), \(y))" }
    }
    
    subscript(direction: Direction) -> Zone {
        return zone(direction)
    }
    
    // Hashable
    
    var hashValue: Int { return x + 100*y }
}

func ZoneSequence(from:Zone, to: Zone) -> [Zone]! {
    
    // invalid cases
    if from.x > to.x || from.y > to.y || (from.x != to.x && from.y != to.y) {
        return nil
    }
    
    var zones = [Zone]()
    
    if from.y == to.y {
        // add x sequence
        for x in stride(from: from.x, through: to.x, by: 1) {
            zones.append(Zone(x, from.y))
        }
        
    } else {
        // add y sequence
        for y in stride(from: from.y, through: to.y, by: 1) {
            zones.append(Zone(from.x, y))
        }
    }

    return zones
}

infix operator ^ {}

func ^ (lhs: Zone, rhs: Direction) -> CGPoint {
    return lhs.worldPoint(rhs)
}

func == (left: Zone, right: Zone) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}

let ZoneZero = Zone(0,0)