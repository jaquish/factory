//
//  TimedTransformer.swift
//  factory
//
//  Created by Zach Jaquish on 2/7/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let ProcessingTime = 1.0

private let Processing: WidgeState = "Processing"

class TimedTransformer: BeltMachine {
    
    var action: TransformerAction
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
    
    init(_ originZone: Zone, action: TransformerAction) {
        
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
        
        upperHalfNode = box
        
        self.userInteractionEnabled = true
    }
    
    required override init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addConnectionPoints() {
        // widge out of the container
        addInput(lowerHalfZone^(.center), name: "belt-input", startingState: Processing)
        addOutput(lowerHalfZone^(.center), name:"belt-output")
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
        
        // from belt
        if let widge = connector("belt-input").dequeueWidge() {
            
            assert(processingTimeRemaining == 0, "Shouldn't receive widges when still processing")
            
            if isOn {
                
                // determine new widge type
                let newType = action.resultForInput(widge.widgeType)
                let transformed = transform(widge, toType: newType)
                transformed.state = Processing
                processingTimeRemaining = ProcessingTime
                cover.hidden = false
                // wait for processing to complete
                
            } else {
                output.insert(widge) // pass through
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        isOn = !isOn
    }
    
    // MARK: BeltMachine
    
    override func baseZone() -> Zone {
        return lowerHalfZone
    }
    
    override func isProcessingWidge() -> Bool {
        return processingTimeRemaining > 0
    }
}
