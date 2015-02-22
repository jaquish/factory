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
        
        self.userInteractionEnabled = true
    }
    
    required override init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addConnectionPoints() {
        // gravity into the container
        addInput(upperHalfZone^(.center), name: "container-input", startingState: Contained)
        
        // no gravity inside of machine, instead, move widges manually
        
        // widge out of the container
        addInput(lowerHalfZone^(.center), name: "belt-input", startingState: Source)
        addOutput(lowerHalfZone^(.center), name:"belt-output")
    }
    
    // MARK: Gameplay Phase
    
    override func update(_dt: CFTimeInterval) {
        
        let output = connector("belt-output")
        
        // Widge undergoing process
        if beltMachineState == .Processing {
            processingTimeRemaining -= _dt
            if processingTimeRemaining <= 0 {
                // End processing
                cover.hidden = true
                processingTimeRemaining = 0
                
                output.insert(widgeInState(Processing))
                beltMachineState = .Open
            }
        }
        
        // Try containing a widge
        if let widge = connector("container-input").dequeueWidge() {
            if widge.widgeType == containedType {
                // type matches, contain it
                containedCount++
            } else {
                // doesn't match, turn all to garbage
                containedCount = 0
                createWidge(widge.widgeType.garbage, position: upperHalfZone^(.center), state: InternalGravity)
                beltMachineState == .MovingIn
            }
            deleteWidge(widge)
        }
        
        // falling widges
        for widge in widgesInState(InternalGravity) {

            let deltaY = -GravityPointsPerSecond * CGFloat(_dt)
            let oldPosition = widge.position
            widge.changeYBy(deltaY)
            
            // fall until hit output to belt
            if path(from: oldPosition, to: widge.position, ranOver:output.position) {
                // TODO: Calculate extra distance delta
                widge.changeYTo(output.position.y)
                output.insert(widge)
                beltMachineState = .Open
            }
        }
        
        // from belt
        if let widge = connector("belt-input").dequeueWidge() {
            
            assert(beltMachineState == .MovingIn, "Should be in correct state")
            
            if isOn && containedCount > 0 {
                
                // determine new widge type
                let newType = action.resultTypeFor(beltInput: widge.widgeType, containedCount: containedCount)
                let transformed = transform(widge, toType: newType)
                
                // start processing
                beltMachineState = .Processing
                transformed.state = Processing
                containedCount--
                processingTimeRemaining = ProcessingTime
                cover.hidden = false
                
            } else {
                // pass through
                beltMachineState = .Open
                output.insert(widge)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let location = (touches.anyObject() as UITouch).locationInNode(self)
        
        // route touch
        if upperHalfNode.containsPoint(location) {
            touchContainer()
        } else if lowerHalfNode.containsPoint(location) {
            touchPowerToggle()
        } else {
            println("Touch not inside combiner. Investigate")
        }
    }
    
    func touchContainer() {
        if beltMachineState == .MovingIn || beltMachineState == .Processing
           || containedCount == 0 {
            return
        }
        
        assert(containedCount > 0, "Can't drop nothing")
        containedCount--
        createWidge(containedType, position: connector("container-input").position, state: InternalGravity)
        beltMachineState = .MovingIn    // No dropping or processing allowed until widge hits middle
    }
    
    func touchPowerToggle() {
        isOn = !isOn
    }
    
    // MARK: BeltMachine
    
    override func baseZone() -> Zone {
        return lowerHalfZone
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
