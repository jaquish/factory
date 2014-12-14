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
        
        for x in stride(from: 0, through: WorldWidth, by: ZoneSize) {
            let numberLabel = UILabel()
            numberLabel.textColor = UIColor.lightGrayColor()
            numberLabel.textAlignment = .Center
            numberLabel.text = "\(Int(x) / Int(ZoneSize))"
            numberLabel.frame = CGRectMake(x, WorldHeight - 15, ZoneSize, 15)
            addSubview(numberLabel)
        }
        
        var yCount = 0
        for y in stride(from: WorldHeight - (ZoneSize / 2), through: 0, by: -ZoneSize) {
            let numberLabel = UILabel()
            numberLabel.textColor = UIColor.lightGrayColor()
            numberLabel.text = "\(yCount)"
            numberLabel.frame = CGRectMake(0, y-7.5, ZoneSize, 15)
            addSubview(numberLabel)
            yCount++
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
