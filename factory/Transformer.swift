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
   
    var action: TransformerAction
    var box:SKSpriteNode!

    var isOn: Bool = true {
        didSet {
            box.color = isOn ? UIColor.greenColor() : UIColor.redColor()
        }
    }
    
    init(_ originZone: Zone, action: TransformerAction) {
        
        self.action = action
        
        super.init(originZone: originZone)
        
        box = Util.zoneBoxWithBorder(UIColor.greenColor(), innerColor: UIColor.darkGrayColor())
        addChild(box)

        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addConnectionPoints() {
        addInput(originZone^(.center), name: "input", startingState: WaitingToTransform)
        addOutput(originZone^(.center), name: "output")
    }
    
    // MARK: Gameplay Phase
    
    override func update(_dt: CFTimeInterval) {
        
        connector("input").dequeueWidges()
        
        for widge in widgesInState(WaitingToTransform) {
            
            if isOn {
                let replacement = transform(widge, toType: action.resultForInput(widge.widgeType))
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

class TransformerAction : Action {
    let transformMapping: [WidgeType:WidgeType]
    
    init(ID: ActionID, transformMapping: [WidgeType:WidgeType]) {
        self.transformMapping = transformMapping
        super.init(ID: ID)
    }
    
    func resultForInput(widgeType: WidgeType) -> WidgeType {
        if let result = transformMapping[widgeType] {
            return result
        } else {
            return widgeType.garbage
        }
    }
}
