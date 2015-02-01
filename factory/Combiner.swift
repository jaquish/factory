//
//  Combiner.swift
//  factory
//
//  Created by Zach Jaquish on 11/28/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let ProcessingTime = 1.0

private let Processing: WidgeState = "Processing"
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
    var containedType: WidgeType { return action.containedInput }
    var action: CombinerAction
    var upperHalfZone:Zone    { return originZone[.N] }
    var lowerHalfZone:Zone { return originZone }
    
    var processingTimeRemaining = 0.0
    
    let upperHalfNode: SKSpriteNode!
    let lowerHalfNode: SKSpriteNode!
    
    let cover: SKSpriteNode!
    
    var isOn: Bool = true {
        didSet {
            upperHalfNode.color = isOn ? UIColor.greenColor() : UIColor.redColor()
        }
    }
    
    init(_ originZone: Zone, action: CombinerAction) {
        
        self.action = action
        
        super.init(originZone: originZone)
        
        lowerHalfNode = Util.combinerBottom()
        addChild(lowerHalfNode)
        
        zPosition = SpriteLayerInFrontOfWidges

        let box = Util.zoneBoxWithBorder(UIColor.greenColor(), innerColor: UIColor.darkGrayColor())
        box.position = ZoneZero.worldPoint(.NW)
        addChild(box)

        cover = Util.zoneBoxWithColor(UIColor.darkGrayColor())
        cover.hidden = true
        addChild(cover) // cover over lower half for processing
        
        // show a preview of the output in the center
        let previewSprite = Widge(widgeType: action.containedInput)
        previewSprite.setScale(0.4)
        previewSprite.position = ZoneZero.worldPoint(.center)
        previewSprite.changeYBy(ZoneHeight*0.20)
        box.addChild(previewSprite)
        
        // Show a count of the number of contained objects
        countLabel = SKLabelNode()
        countLabel.position = ZoneZero.worldPoint(.center)
        countLabel.changeYBy(-ZoneHeight*0.40)
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
            
            if processingTimeRemaining > 0 {
                println("Can't drop widge during processing")
                return
            }
            
            if containedCount > 0 {
                containedCount--
                // drop contained type
                let created = Widge(widgeType: containedType)
                scene?.addChild(created)
                created.position = connector("container-input").position
                created.owner = self
                created.state = InternalGravity
            }
        } else if lowerHalfNode.containsPoint(location) {
            isOn = !isOn
        } else {
            println("Touch not inside combiner. Investigate")
        }
    }
    
    // MARK: Gameplay Phase
    
    override func update(_dt: CFTimeInterval) {
        
        let output = connector("belt-output")
        
        // Processing
        if processingTimeRemaining > 0 {
            processingTimeRemaining -= _dt
            if processingTimeRemaining <= 0 {
                // End processing
                cover.hidden = true
                processingTimeRemaining = 0
                
                for widge in widgesInState(Processing) {
                    output.insert(widge)
                }
            }
        }
        
        // into container
        for widge in connector("container-input").dequeueWidges() {
            if widge.widgeType == containedType {
                containedCount++
            } else {
                containedCount = 0
                createWidge(widge.widgeType.garbage, position: upperHalfZone^(.center), state: InternalGravity)
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
            
            assert(processingTimeRemaining == 0, "Shouldn't receive widges when still processing")
            
            if isOn && containedCount > 0 {
                
                // determine new widge type
                let newType = action.resultTypeFor(beltInput: widge.widgeType, containedCount: containedCount)
                let transformed = transform(widge, toType: newType)
                transformed.state = Processing
                containedCount--
                processingTimeRemaining = ProcessingTime
                cover.hidden = false
                // wait for processing to complete
                
            } else {
                output.insert(widge) // pass through
            }
        }
    }
    
    // MARK: BeltMachine
    
    override func baseZone() -> Zone {
        return lowerHalfZone
    }
    
    override func isProcessingWidge() -> Bool {
        return processingTimeRemaining > 0
    }
}

class CombinerAction : Action {
    let containedInput: WidgeType
    let requiredCount: Int
    let successBeltInput: WidgeType
    let mapping: [WidgeType:WidgeType]
    
    func resultTypeFor(#beltInput: WidgeType, containedCount: Int) -> WidgeType {
        assert(containedCount >= requiredCount, "Shouldn't call unless count is enough")
        if let mapped = mapping[beltInput] {
            return mapped
        } else {
            return beltInput.garbage
        }
    }
    
    init(ID: ActionID, containedInput: WidgeType, count: Int, successType: WidgeType, mapping:[WidgeType:WidgeType]) {
        self.containedInput = containedInput
        self.requiredCount = count
        self.successBeltInput = successType
        self.mapping = mapping
        
        super.init(ID: ID)
    }
}
