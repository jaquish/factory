//
//  FGUtil.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

let kBorderInset:CGFloat = 5.0

typealias FGZone = CGPoint

enum CompassPoint {
    case N, NE, E, SE, S, SW, W, NW, center
}

class FGUtil : NSObject {
    
    class func zoneBoxWithColor(color: UIColor) -> SKSpriteNode {
        let box = SKSpriteNode(texture: nil, color: color, size: CGSizeMake(ZoneSize, ZoneSize))
        box.anchorPoint = CGPointZero
        return box
    }
    
    class func zoneBoxWithBorder(color: UIColor, innerColor: UIColor) -> SKSpriteNode {
        let box = SKSpriteNode(texture: nil, color: color, size: CGSizeMake(ZoneSize, ZoneSize))
        box.anchorPoint = CGPointZero
        
        let inner = SKSpriteNode(texture: nil, color: innerColor, size:CGSizeMake(ZoneSize - 2*kBorderInset, ZoneSize - 2*kBorderInset))
        inner.anchorPoint = CGPointZero
        inner.position = CGPointMake(kBorderInset, kBorderInset)
        
        box.addChild(inner)
        return box
    }
}

let FGZoneZero = FGZoneMake(0,0)

func FGZoneMake(x: CGFloat, y: CGFloat) -> FGZone
{
    var z = FGZone()
    z.x = x
    z.y = y
    return z;
}

func compassPointOfZone(cp: CompassPoint, z: FGZone) -> CGPoint
{
    switch (cp) {
        case .N:     return CGPointMake(ZoneSize * (z.x + 0.5), ZoneSize * (z.y + 1.0));
        case .NE:    return CGPointMake(ZoneSize * (z.x + 1.0), ZoneSize * (z.y + 1.0));
        case .E:     return CGPointMake(ZoneSize * (z.x + 1.0), ZoneSize * (z.y + 0.5));
        case .SE:    return CGPointMake(ZoneSize * (z.x + 1.0), ZoneSize * (z.y      ));
        case .S:     return CGPointMake(ZoneSize * (z.x + 0.5), ZoneSize * (z.y      ));
        case .SW:    return CGPointMake(ZoneSize * (z.x      ), ZoneSize * (z.y      ));
        case .W:     return CGPointMake(ZoneSize * (z.x      ), ZoneSize * (z.y + 0.5));
        case .NW:    return CGPointMake(ZoneSize * (z.x      ), ZoneSize * (z.y + 1.0));
        case .center:return CGPointMake(ZoneSize * (z.x + 0.5), ZoneSize * (z.y + 0.5));
    }
}

func centerOf(z: FGZone) -> CGPoint {
    return compassPointOfZone(.center, z);
}

func zoneInDirectionFromZone(cp: CompassPoint, z: FGZone) -> FGZone {
    switch (cp) {
    case .N:     return FGZoneMake(z.x    , z.y + 1)
    case .NE:    return FGZoneMake(z.x + 1, z.y + 1)
    case .E:     return FGZoneMake(z.x + 1, z.y    )
    case .SE:    return FGZoneMake(z.x + 1, z.y - 1)
    case .S:     return FGZoneMake(z.x    , z.y - 1)
    case .SW:    return FGZoneMake(z.x - 1, z.y - 1)
    case .W:     return FGZoneMake(z.x - 1, z.y    )
    case .NW:    return FGZoneMake(z.x - 1, z.y + 1)
    case .center:return z;
    }
}

extension SKNode {
    
    func changeXBy(deltaX: CGFloat) {
        var pos = self.position
        pos.x += deltaX
        self.position = pos
    }
    
    func changeXTo(x: CGFloat) {
        var pos = self.position
        pos.x = x
        self.position = pos
    }
    
    func changeYBy(deltaY: CGFloat) {
        var pos = self.position
        pos.y += deltaY
        self.position = pos
    }
    
    func changeYTo(y: CGFloat) {
        var pos = self.position
        pos.y = y
        self.position = pos
    }
}