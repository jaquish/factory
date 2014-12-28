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
        self.containedType = action.inputTypeIDs.first!
        
        super.init(originZone: originZone)
        
        let bottom = Util.combinerBottom()
        addChild(bottom)
        
        zPosition = SpriteLayerInFrontOfWidges

        let box = Util.zoneBoxWithBorder(UIColor.blueColor(), innerColor: UIColor.darkGrayColor())
        box.position = ZoneZero.worldPoint(.NW)
        addChild(box)
        
        // show a preview of the output in the center
        let a = Widge.widgeBy(containedType)!
        a.setScale(0.4)
        a.position = ZoneZero.worldPoint(.center)
        a.changeYBy(ZoneSize*0.20)
        box.addChild(a)
        
//        // gravity into the container
//        let cpInput = ConnectionPoint(position:originZone[.N].worldPoint(.center), name: "container-input")
//        self.addInput(cpInput)
//        
//        // widge out of the container
//        let cpOutput = ConnectionPoint(position: originZone.zone(.N).worldPoint(.center), name: "drop-output")
//        self.addOutput(cpOutput)
//        
//        let cpInput2 = ConnectionPoint(position: originZone.worldPoint(.center), name: "belt-input")
//        self.addInput(cpInput2)
        
        countLabel = SKLabelNode()
        countLabel.position = ZoneZero.worldPoint(.center)
        countLabel.changeYBy(-ZoneSize*0.40)
        countLabel.fontSize = LabelFontSize
        box.addChild(countLabel)
        
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
        // Container
        var madeGarbage = false
        for widge in connectorWithName("container-input").dequeueWidges() {
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
            garbage.position = connectorWithName("drop-output").position
            connectorWithName("drop-output").insert(garbage)
        }
    }
}
