//
//  GridNumbering.swift
//  factory
//
//  Created by Zach Jaquish on 12/14/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

class GridNumbering: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        
        // different coordinate system than sprite kit
        
        for x in stride(from: 0, through: WorldWidth, by: ZoneWidth) {
            let numberLabel = UILabel()
            numberLabel.textColor = UIColor.lightGrayColor()
            numberLabel.textAlignment = .Center
            numberLabel.text = "\(Int(x) / Int(ZoneWidth))"
            numberLabel.frame = CGRectMake(x, WorldHeight - 15, ZoneWidth, 15)
            addSubview(numberLabel)
        }
        
        var yCount = 0
        for y in stride(from: WorldHeight - (ZoneHeight / 2), through: 0, by: -ZoneHeight) {
            let numberLabel = UILabel()
            numberLabel.textColor = UIColor.lightGrayColor()
            numberLabel.text = "\(yCount)"
            numberLabel.frame = CGRectMake(0, y-7.5, ZoneHeight, 15)
            addSubview(numberLabel)
            yCount++
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
