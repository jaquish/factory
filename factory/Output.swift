//
//  Output.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class Output: Machine {
    
    let label: SKLabelNode
    var count: Int = 0 {
        didSet {
            label.text = "\(count)"
        }
    }
    
    override init(originZone: FGZone) {
        
        let title = SKLabelNode()
        title.position = compassPointOfZone(.center, FGZoneZero)
        title.position.y += 8
        title.fontSize = LabelFontSize
        title.text = "OUT"
        
        label = SKLabelNode()
        label.position = compassPointOfZone(.center, FGZoneZero)
        label.position.y -= 25
        label.fontSize = LabelFontSize
        
        super.init(originZone: originZone)
        
        addChild(FGUtil .zoneBoxWithBorder(UIColor.grayColor(), innerColor:UIColor(red: 0.2, green: 0.2, blue: 0.8, alpha: 1.0)))
        addChild(title)
        addChild(label)
        addSimpleInput("input")
        
        self.color = UIColor.grayColor().colorWithAlphaComponent(0.2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        let widges = connectors["input"]!.dequeueWidges()
        count += widges.count
        
        widges.map { $0.removeFromParent() }
    }
}
