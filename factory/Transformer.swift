//
//  Transformer.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class Transformer: Machine {
   
    let finalColor: UIColor
    var action: Action
    
    init(_ originZone: Zone, color: UIColor, action: Action) {
        finalColor = color
        
        self.action = action
        
        super.init(originZone: originZone)
        
        addChild(Util.zoneBoxWithBorder(finalColor, innerColor: UIColor.darkGrayColor()))
        
        addSimpleInput("input")
        addSimpleOutput("output")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        let inputWidges = connectors["input"]!.dequeueWidges()
        
        for widge in inputWidges {
            
            let newType = action.performAction([widge.widgeTypeID]).first!
            
            let replacement = level.createWidge(newType)
            replacement.position = widge.position
            
            scene?.addChild(replacement)
            widge.removeFromParent()
            
            connectors["output"]!.insert(replacement)
        }
    }
}
