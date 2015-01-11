//
//  Container.swift
//  factory
//
//  Created by Zach Jaquish on 11/28/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let Contained: WidgeState = "Contained"
private let ReadyToDrop: WidgeState = "ReadyToDrop"

class Container: Machine {
   
    var containedCount: Int = 0 {
        didSet {
            countLabel.text = "\(containedCount)"
        }
    }
    var countLabel: SKLabelNode!
    var containedType: String!
    
    init(_ originZone: Zone, containedType: String) {
        
        self.containedType = containedType
        
        super.init(originZone: originZone)
        
        let box = Util.zoneBoxWithBorder(UIColor.blueColor(), innerColor: UIColor.darkGrayColor())
        addChild(box)
        
        // show a preview of the output in the center
        let outputPreview = Widge.widgeBy(containedType)!
        outputPreview.setScale(0.5)
        addChild(outputPreview)
        outputPreview.position = ZoneZero.worldPoint(.center)
        outputPreview.changeYBy(ZoneSize*0.20)
        
        addInput(originZone^(.center), name: "input", startingState: Contained)
        addOutput(originZone^(.center), name: "output")
        
        countLabel = SKLabelNode()
        countLabel.position = ZoneZero.worldPoint(.center)
        countLabel.changeYBy(-ZoneSize*0.40)
        countLabel.fontSize = LabelFontSize
        addChild(countLabel)
        
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Gameplay Phase
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if containedCount > 0 {
            containedCount--
            
            // drop contained type
            let output = connector("output")
            let dropped = createWidge(containedType, position: output.position, state: ReadyToDrop)
            output.insert(dropped)
        }
    }
    
    override func update(_dt: CFTimeInterval) {
        
        dequeueAllWidges()
        
        var madeGarbage = false
        for widge in connector("input").dequeueWidges() {
            if widge.widgeType == containedType {
                containedCount++
            } else {
                madeGarbage = true
            }
            
            deleteWidge(widge)
        }
        if madeGarbage {
            // Oh no! sound
            containedCount = 0
            
            let output = connector("output")
            let garbage = createWidge("garbage", position: output.position, state: ReadyToDrop)
            output.insert(garbage)
        }
    }
}
