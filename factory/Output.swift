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
    
    init(_ originZone: Zone) {
        
        let title = SKLabelNode()
        title.position = ZoneZero.worldPoint(.center)
        title.position.y += 4
        title.fontSize = LabelFontSize
        title.text = "OUT"
        
        label = SKLabelNode()
        label.position = ZoneZero.worldPoint(.center)
        label.position.y -= 20
        label.fontSize = LabelFontSize
        
        super.init(originZone: originZone)
        
        addChild(Util .zoneBoxWithBorder(UIColor.grayColor(), innerColor:UIColor(red: 0.2, green: 0.2, blue: 0.8, alpha: 1.0)))
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
        widges.map { self.level.addOutput($0.widgeTypeID) }
        widges.map { $0.removeFromParent() }
    }
}
