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

enum Direction : String {
    case N = "N"
    case NE = "NE"
    case E = "E"
    case SE = "SE"
    case S = "S"
    case SW = "SW"
    case W = "W"
    case NW = "NW"
    case center = "center"
}

func opposite(direction: Direction) -> Direction {
    switch direction {
    case .N: return .S
    case .NE:return .SW
    case .E: return .W
    case .SE:return .NW
    case .S: return .N
    case .SW:return .NE
    case .W: return .E
    case .NW:return .SE
    case .center:return .center
    }
}

class Util : NSObject {
    
    class func zoneBoxWithColor(color: UIColor) -> SKSpriteNode {
        let box = SKSpriteNode(texture: nil, color: color, size: ZoneSize)
        box.userInteractionEnabled = false
        box.anchorPoint = CGPointZero
        return box
    }
    
    class func combinerBottom() -> SKSpriteNode {
        let box = SKSpriteNode(texture: nil, color: UIColor.clearColor(), size: ZoneSize)
        
        let left = SKSpriteNode(texture: nil, color: UIColor.grayColor(), size: CGSizeMake(0.1*ZoneWidth, ZoneHeight))
        left.anchorPoint = CGPointZero
        left.position = CGPointZero
        box.addChild(left)
        
        let right = SKSpriteNode(texture: nil, color: UIColor.grayColor(), size: CGSizeMake(0.1*ZoneWidth, ZoneHeight))
        right.anchorPoint = CGPointZero
        right.position = CGPointMake(ZoneWidth*0.9, 0)
        box.addChild(right)
        
        box.userInteractionEnabled = false
        box.anchorPoint = CGPointZero
        return box
    }
    
    class func zoneBoxWithBorder(color: UIColor, innerColor: UIColor) -> SKSpriteNode {
        let box = SKSpriteNode(texture: nil, color: color, size: ZoneSize)
        box.anchorPoint = CGPointZero
        
        let inner = SKSpriteNode(texture: nil, color: innerColor, size:CGSizeMake(ZoneWidth - 2*kBorderInset, ZoneHeight - 2*kBorderInset))
        inner.anchorPoint = CGPointZero
        inner.userInteractionEnabled = false
        inner.position = CGPointMake(kBorderInset, kBorderInset)
        
        box.addChild(inner)
        return box
    }
}

extension Array {
    func randomItem() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
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

// doesn't include from == ranOver
func path(#from:CGPoint, #to:CGPoint, #ranOver:CGPoint) -> Bool {
    if (from.x == to.x && to.x == ranOver.x) {
        return min(from.y, to.y)...max(from.y, to.y) ~= ranOver.y && from.y != ranOver.y
    } else if (from.y == to.y && to.y == ranOver.y) {
        return min(from.x, to.x)...max(from.x, to.x) ~= ranOver.x && from.x != ranOver.x
    } else {
        return false
    }
}

func path(#from:CGFloat, #to:CGFloat, #ranOver:CGFloat) -> Bool {
    return min(from, to)...max(from, to) ~= ranOver && from != ranOver
}