//
//  Combiner.swift
//  factory
//
//  Created by Zach Jaquish on 11/28/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let Contained: WidgeState = "Contained"
private let Source: WidgeState = "Source"
private let InternalGravity: WidgeState = "InternalGravity"

class Combiner: BeltMachine {

    var containedCount: Int = 0 {
        didSet {
            countLabel.text = "\(containedCount)"
        }
    }
    var countLabel: SKLabelNode!
    var containedType: String { return action.containedType() }
    var action: CombinationAction
    
    var upperHalfZone:Zone    { return originZone[.N] }
    var lowerHalfZone:Zone { return originZone }
    
    let upperHalfNode: SKNode!
    let lowerHalfNode: SKNode!
    
    var isOn: Bool = true
    
    init(_ originZone: Zone, action: CombinationAction) {
        
        self.action = action
        
        super.init(originZone: originZone)
        
        lowerHalfNode = Util.combinerBottom()
        addChild(lowerHalfNode)
        
        zPosition = SpriteLayerInFrontOfWidges

        let box = Util.zoneBoxWithBorder(UIColor.blueColor(), innerColor: UIColor.darkGrayColor())
        box.position = ZoneZero.worldPoint(.NW)
        addChild(box)
        
        // show a preview of the output in the center
        let a = Widge.widgeBy(action.containedType() , isPreview: true)!
        a.setScale(0.4)
        a.position = ZoneZero.worldPoint(.center)
        a.changeYBy(ZoneSize*0.20)
        box.addChild(a)
        
        // Show a count of the number of contained objects
        countLabel = SKLabelNode()
        countLabel.position = ZoneZero.worldPoint(.center)
        countLabel.changeYBy(-ZoneSize*0.40)
        countLabel.fontSize = LabelFontSize
        countLabel.text = "0"
        box.addChild(countLabel)
        
        upperHalfNode = box
        
        // gravity into the container
        addInput(upperHalfZone^(.center), name: "container-input", startingState: Contained)

        // no gravity inside of machine, instead, move widges manually
        
        // widge out of the container
        addInput(lowerHalfZone^(.center), name: "belt-input", startingState: Source)
        addOutput(lowerHalfZone^(.center), name:"belt-output")
        
        
        
        self.userInteractionEnabled = true
    }
    
    required override init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let location = (touches.anyObject() as UITouch).locationInNode(self)
        
        if upperHalfNode.containsPoint(location) {
            if containedCount > 0 {
                containedCount--
                // drop contained type
                let created = Widge.widgeBy(containedType)!
                scene?.addChild(created)
                created.position = connector("container-input").position
                created.owner = self
                created.state = InternalGravity
            }
        } else if lowerHalfNode.containsPoint(location) {
            println("Lower half touch")
        } else {
            println("Touch not inside combiner. Investigate")
        }
    }
    
    override func update(_dt: CFTimeInterval) {
        
        let output = connector("belt-output")
        
        // into container
        for widge in connector("container-input").dequeueWidges() {
            if widge.widgeType == containedType {
                containedCount++
            } else {
                containedCount = 0
                createWidge("purple", position: upperHalfZone^(.center), state: InternalGravity)
            }
            deleteWidge(widge)
        }
        
        // falling widges
        for widge in widgesInState(InternalGravity) {
            let deltaY = -GravityPointsPerSecond * CGFloat(_dt)
            let oldPosition = widge.position
            widge.changeYBy(deltaY)
            
            if path(from: oldPosition, to: widge.position, ranOver:output.position) {
                // TODO: Calculate extra distance delta
                widge.changeYTo(output.position.y)
                output.insert(widge)
            }
        }
        
        // from belt
        if let widge = connector("belt-input").dequeueWidge() {
            
            if isOn && containedCount > 0 {
                // determine new widge type
                let determinedType = action.resultType(beltInput: widge.widgeType, containedInput: containedType)
                let transformed = transform(widge, toType: determinedType)
                containedCount--
                connector("belt-output").insert(transformed)
            } else {
                connector("belt-output").insert(widge) // pass through
            }
        }
    }
}
