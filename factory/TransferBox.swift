//
//  TransferBox.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let WaitingToTransfer: WidgeState = "WaitingToTransfer"

class TransferBox: Machine {

    init(_ originZone: Zone) {
        super.init(originZone: originZone)
        zPosition = SpriteLayerInFrontOfWidges
        
        addChild(Util.zoneBoxWithBorder(UIColor.darkGrayColor(), innerColor: UIColor.grayColor()))
        
        // up to 3 inputs
        for i in 0..<3 {
            addInput(originZone^(.center), name: "input-\(i)", startingState: WaitingToTransfer, priority: 1)
        }

        // only 1 output
        addOutput(originZone^(.center), name: "output", priority: 1)
    }
    
    // MARK: Connection Phase
    
    override func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        // don't input to a machine that's an output
        let result = !contains(connectionPointOutputs.filter{$0.connector != nil}.map{$0.connector!.destination}, machine)
        if !result {
            println("\(self) denied incoming connection from \(machine) at \(inputPoint)")
        }
        return result
    }
    
    override func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        // don't output to a machine that's an input
        let alreadyInput = contains(connectionPointInputs.filter{$0.connector != nil}.map{$0.connector!.source}, machine)
        if machine is Belt {
            // don't output to last tile of a belt
            return !alreadyInput && Zone(containingPoint: outputPoint.position) != (machine as Belt).lastZone
        } else if machine is VerticalBelt {
            return !alreadyInput && Zone(containingPoint: outputPoint.position) != (machine as VerticalBelt).lastZone
        } else {
            return !alreadyInput
        }
    }
    
    override func validateConnections() {
        let outputCount = outputs().count
        assert(outputCount == 1, "Expected \(self) to have 1 output, not \(outputCount)")
        
        let inputCount = inputs().count
        assert(inputCount >= 1, "Expected \(self) to have at least input, not \(inputCount)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Game Phase
    
    override func update(_dt: CFTimeInterval) {
        
        dequeueAllWidges()
        
        for widge in widgesInState(WaitingToTransfer) {
            connector("output").insert(widge)
        }
    }

    override func description() -> String {
        return "Transfer box at \(originZone)"
    }
}
