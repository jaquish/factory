//
//  Zone.swift
//  factory
//
//  Created by Zach Jaquish on 11/12/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import Foundation
import UIKit

struct Zone {
    var x: Int
    var y: Int
    
    // shortcut initializer
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func worldPoint(cp: CompassPoint) -> CGPoint {
        switch (cp) {
            case .N:     return CGPointMake(ZoneSize * (CGFloat(x) + 0.5), ZoneSize * (CGFloat(y) + 1.0));
            case .NE:    return CGPointMake(ZoneSize * (CGFloat(x) + 1.0), ZoneSize * (CGFloat(y) + 1.0));
            case .E:     return CGPointMake(ZoneSize * (CGFloat(x) + 1.0), ZoneSize * (CGFloat(y) + 0.5));
            case .SE:    return CGPointMake(ZoneSize * (CGFloat(x) + 1.0), ZoneSize * (CGFloat(y)      ));
            case .S:     return CGPointMake(ZoneSize * (CGFloat(x) + 0.5), ZoneSize * (CGFloat(y)      ));
            case .SW:    return CGPointMake(ZoneSize * (CGFloat(x)      ), ZoneSize * (CGFloat(y)      ));
            case .W:     return CGPointMake(ZoneSize * (CGFloat(x)      ), ZoneSize * (CGFloat(y) + 0.5));
            case .NW:    return CGPointMake(ZoneSize * (CGFloat(x)      ), ZoneSize * (CGFloat(y) + 1.0));
            case .center:return CGPointMake(ZoneSize * (CGFloat(x) + 0.5), ZoneSize * (CGFloat(y) + 0.5));
        }
    }
    
    func zone(cp: CompassPoint) -> Zone {
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
}

let ZoneZero = Zone(0,0)