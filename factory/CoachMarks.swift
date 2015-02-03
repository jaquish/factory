//
//  Helpers.swift
//  factory
//
//  Created by Zach Jaquish on 2/1/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    
    convenience init(coachMarkForWidgeType widgeType: WidgeType, direction: Direction) {
        self.init(texture: nil, color: nil, size: ZoneSize)
        
        let miniWidge = Widge(widgeType: widgeType)
        miniWidge.xScale = 0.4
        miniWidge.yScale = 0.4
        miniWidge.position = insetFromDirection(opposite(direction))
        
        addChild(miniWidge)
        
        let arrow = SKLabelNode(text: arrowCharForDirection(direction))
        arrow.fontSize = 24.0
        arrow.verticalAlignmentMode = .Center
        arrow.position = insetFromDirection(direction)
        
        addChild(arrow)
    }
    
    convenience init(coachMarkForTransformationFrom from: WidgeType, to: WidgeType, direction: Direction) {
        self.init(texture: nil, color: nil, size: ZoneSize)
        
        let miniInput = Widge(widgeType: from)
        miniInput.xScale = 0.4
        miniInput.yScale = 0.4
        miniInput.position = insetFromDirection(opposite(direction))
        addChild(miniInput)
        
        let miniOutput = Widge(widgeType: to)
        miniOutput.xScale = 0.4
        miniOutput.yScale = 0.4
        miniOutput.position = insetFromDirection(direction)
        addChild(miniOutput)
        
        let arrow = SKLabelNode(text: arrowCharForDirection(direction))
        arrow.fontSize = 24.0
        arrow.verticalAlignmentMode = .Center
        arrow.zPosition = 1
        addChild(arrow)
    }
    
    func arrowCharForDirection(d: Direction) -> String {
        switch d {
        case .N : return "\u{2191}"
        case .NE: return "\u{2197}"
        case .E : return "\u{2192}"
        case .SE: return "\u{2198}"
        case .S : return "\u{2193}"
        case .SW: return "\u{2199}"
        case .W : return "\u{2190}"
        case .NW: return "\u{2196}"
        case .center: return ""
        }
    }
    
    func insetFromDirection(direction: Direction) -> CGPoint {
        switch direction {
        case .N: return CGPointMake(0, 0.25*size.height)
        case .E: return CGPointMake(0.25*size.width, 0)
        case .S: return CGPointMake(0,-0.25*size.height)
        case .W: return CGPointMake(-0.25*size.width, 0)
        default: return CGPointZero
        }
    }
}
