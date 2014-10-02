//
//  Input.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class Input: Machine {
   
    var generated: [Widge]
    
    override init(originZone: FGZone) {
        generated = Array()
        super.init(originZone: originZone)
        
        addChild(FGUtil.zoneBoxWithBorder(UIColor.grayColor(), innerColor: UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0)))
        
        let label = SKLabelNode()
        label.verticalAlignmentMode = .Center
        label.position = centerOf(FGZoneZero)
        label.text = "IN"
        label.fontSize = LabelFontSize
        addChild(label)
        
        addSimpleOutput("next")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        generateWidge()
    }
    
    func generateWidge() {
        let widge = Widge.redWidge()
        widge.position = compassPointOfZone(.center, originZone)
        generated.append(widge)
        scene?.addChild(widge)
    }
    
    override func update(_dt: CFTimeInterval) {
        for widge in generated {
            connectors["next"]?.insert(widge)
        }
        generated.removeAll()
    }
}
