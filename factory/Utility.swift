//
//  Util.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

let kBorderInset:CGFloat = 5.0

enum CompassPoint {
    case N, NE, E, SE, S, SW, W, NW, center
}

class Util : NSObject {
    
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