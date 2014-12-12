//
//  Combiner.swift
//  factory
//
//  Created by Zach Jaquish on 11/28/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class Combiner: Machine {

    var containedCount: Int = 0 {
        didSet {
            countLabel.text = "\(containedCount)"
        }
    }
    var countLabel: SKLabelNode!
    var containedType: String!
    var action: Action
    
    init(_ originZone: Zone, action: Action) {
        
        self.action = action
        
        super.init(originZone: originZone)
        
        let bottom = Util.combinerBottom()
        addChild(bottom)
        
        zPosition = SpriteLayerInFrontOfWidges

        let box = Util.zoneBoxWithBorder(UIColor.blueColor(), innerColor: UIColor.darkGrayColor())
        box.position = originZone.worldPoint(.NW)
        addChild(box)
        
        // show a preview of the output in the center
        let outputPreview = Widge.widgeBy(containedType)!
        outputPreview.setScale(0.5)
        outputPreview.position = ZoneZero.worldPoint(.center)
        outputPreview.changeYBy(ZoneSize*0.20)
        box.addChild(outputPreview)

        addSimpleInput("input")
        addSimpleOutput("output")
        
        countLabel = SKLabelNode()
        countLabel.position = ZoneZero.worldPoint(.center)
        countLabel.changeYBy(-ZoneSize*0.40)
        countLabel.fontSize = LabelFontSize
        addChild(countLabel)
        
        self.userInteractionEnabled = true
    }
    
    override func didMakeConnections() {
        containedCount = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if containedCount > 0 {
            containedCount--
            // drop contained type
            let created = Widge.widgeBy(containedType)!
            scene?.addChild(created)
            created.position = connectorWithName("output").position
            connectorWithName("output").insert(created)
        }
    }
    
    override func update(_dt: CFTimeInterval) {
        var madeGarbage = false
        for widge in connectorWithName("input").dequeueWidges() {
            if widge.widgeTypeID == containedType {
                containedCount++
            } else {
                madeGarbage = true
            }
            widge.removeFromParent()
        }
        if madeGarbage {
            // Oh no!
            containedCount = 0
            let garbage = Widge.garbage()
            scene?.addChild(garbage)
            garbage.position = connectorWithName("output").position
            connectorWithName("output").insert(garbage)
        }
    }
}
