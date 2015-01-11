//
//  Transformer.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let WaitingToTransform: WidgeState = "WaitingToTransform"

class Transformer: Machine {
   
    var action: TransformAction
    var box:SKSpriteNode!

    var isOn: Bool = true {
        didSet {
            box.color = isOn ? UIColor.greenColor() : UIColor.redColor()
        }
    }
    
    init(_ originZone: Zone, action: TransformAction) {
        
        self.action = action
        
        super.init(originZone: originZone)
        
        box = Util.zoneBoxWithBorder(UIColor.greenColor(), innerColor: UIColor.darkGrayColor())
        addChild(box)
        
        // show a preview of the output in the center
        let outputPreview = Widge.widgeBy(action.successType(), isPreview: true)!
        outputPreview.setScale(0.5)
        addChild(outputPreview)
        outputPreview.position = ZoneZero.worldPoint(.center)
        
        addInput(originZone^(.center), name: "input", startingState: WaitingToTransform)
        addOutput(originZone^(.center), name: "output")
        
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Gameplay Phase
    
    override func update(_dt: CFTimeInterval) {
        
        connector("input").dequeueWidges()
        
        for widge in widgesInState(WaitingToTransform) {
            
            if isOn {
                let replacement = transform(widge, toType: action.resultType(input: widge.widgeType))
                connector("output").insert(replacement)
                
            } else {
                connector("output").insert(widge)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        isOn = !isOn
    }
    
    // MARK: Debug 
    
    override func description() -> String {
        return "Transformer at \(originZone) action=\(action) isOn=\(isOn)"
    }
}
