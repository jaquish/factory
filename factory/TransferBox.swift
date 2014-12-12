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

    init(_ originZone: Zone) {
        super.init(originZone: originZone)
        zPosition = SpriteLayerInFrontOfWidges
        
        addChild(Util.zoneBoxWithBorder(UIColor.darkGrayColor(), innerColor: UIColor.grayColor()))
        
        // up to 3 inputs
        for i in 0..<3 {
            let input = ConnectionPoint(position: originZone.worldPoint(.center), name: "input-\(i)")
            input.priority = 1
            addInput(input)
        }

        // only 1 output
        let output = ConnectionPoint(position: originZone.worldPoint(.center), name: "output")
        output.priority = 1
        addOutput(output)
    }
    
    override func didMakeConnections() {
        let outputCount = outputs().count
        assert(outputCount == 1, "Expected transfer box to have 1 output, not \(outputCount)")
        
        let inputCount = inputs().count
        assert(inputCount >= 1, "Expected transfer box to have at least input, not \(inputCount)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        for connector in inputs() {
            for widge in connector.dequeueWidges() {
                connectorWithName("output").insert(widge)
            }
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
