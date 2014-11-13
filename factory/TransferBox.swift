//
//  TransferBox.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class TransferBox: Machine {

    override init(originZone: Zone) {
        super.init(originZone: originZone)
        zPosition = SpriteLayerInFrontOfWidges
        
        addChild(Util.zoneBoxWithBorder(UIColor.darkGrayColor(), innerColor: UIColor.grayColor()))
        
        let input = ConnectionPoint(position: originZone.worldPoint(.center), name: "input")
        input.priority = 1
        addInput(input)
        
        let output = ConnectionPoint(position: originZone.worldPoint(.center), name: "output")
        input.priority = 1
        addOutput(output)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        for widge in connectorWithName("input").dequeueWidges() {
            connectorWithName("output").insert(widge)
        }
    }
    
    override func allowConnectionWith(machine: Machine) -> Bool {
        for cp in connectionPointInputs + connectionPointOutputs {
            if cp.connector?.source == machine || cp.connector?.destination == machine {
                return false  // don't connect to a machine that you've already connected to
            }
        }
        return true
    }
}
