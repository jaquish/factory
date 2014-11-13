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
    
    init(_ originZone: Zone, color: UIColor) {
        finalColor = color
        super.init(originZone: originZone)
        
        addChild(Util.zoneBoxWithBorder(finalColor, innerColor: UIColor.darkGrayColor()))
        
        addSimpleInput("input")
        addSimpleOutput("output")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        let widges = connectors["input"]!.dequeueWidges()
        
        for widge in widges {
            let replacement = Widge.widgeWith(finalColor)
            replacement.position = widge.position
            
            scene?.addChild(replacement)
            widge.removeFromParent()
            
            connectors["output"]!.insert(replacement)
        }
    }
}
