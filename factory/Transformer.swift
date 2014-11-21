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
    var box:SKSpriteNode!

    var isOn: Bool = true {
        didSet {
            box.color = isOn ? UIColor.greenColor() : UIColor.redColor()
        }
    }
    
    init(_ originZone: Zone, action: Action) {
        
        self.action = action
        
        super.init(originZone: originZone)
        
        box = Util.zoneBoxWithBorder(UIColor.greenColor(), innerColor: UIColor.darkGrayColor())
        addChild(box)
        
        // show a preview of the output in the center
        let outputType = action.successTypeIDs.first!
        let outputPreview = Widge.widgeBy(outputType)!
        outputPreview.setScale(0.5)
        addChild(outputPreview)
        outputPreview.position = ZoneZero.worldPoint(.center)
        
        addSimpleInput("input")
        addSimpleOutput("output")
        
//        self.size = self.calculateAccumulatedFrame().size necessary?
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        let inputWidges = connectors["input"]!.dequeueWidges()
        
        for widge in inputWidges {
            
            if isOn {
                let newType = action.performAction([widge.widgeTypeID]).first!
                
                let replacement = CurrentLevel.createWidge(newType)
                replacement.position = widge.position
                
                scene?.addChild(replacement)
                widge.removeFromParent()
                
                connectors["output"]!.insert(replacement)
                
            } else {
                connectors["output"]!.insert(widge)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        isOn = !isOn
    }
}
