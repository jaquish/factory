//
//  GridOverlay.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

class GridOverlay: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        
        CGContextSetLineWidth(context, 1.0)
        
        // draw lines from lower left, which is a different coordinate system than sprite kit
        // this way, remainders (when length is not divisible by ZoneSize) show correctly as top and right
        
        for x in stride(from: 0, through: WorldWidth, by: ZoneSize) {
            CGContextMoveToPoint(context, x, 0)              // start at this point
            CGContextAddLineToPoint(context, x, WorldHeight) // draw to this point
            CGContextStrokePath(context)                     // and now draw the path
        }
        
        for y in stride(from: WorldHeight, through: 0, by: -ZoneSize) {
            CGContextMoveToPoint(context, 0, y)              // start at this point
            CGContextAddLineToPoint(context, WorldWidth, y)  // draw to this point
            CGContextStrokePath(context)                     // and now draw the path
        }
    }
}
