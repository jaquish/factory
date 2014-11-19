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
   
    var action: Action
    
    init(_ originZone: Zone, action: Action) {
        
        self.action = action
        
        super.init(originZone: originZone)
        
        addChild(Util.zoneBoxWithBorder(UIColor.greenColor(), innerColor: UIColor.darkGrayColor()))
        
        // show a preview of the output in the center
        let outputType = action.successTypeIDs.first!
        let outputPreview = CurrentLevel.createWidge(outputType)
        outputPreview.setScale(0.5)
        addChild(outputPreview)
        outputPreview.position = ZoneZero.worldPoint(.center)
        
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
            
            let replacement = CurrentLevel.createWidge(newType)
            replacement.position = widge.position
            
            scene?.addChild(replacement)
            widge.removeFromParent()
            
            connectors["output"]!.insert(replacement)
        }
    }
}
