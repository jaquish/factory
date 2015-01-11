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
        return machine is Mover && (machine as Mover).stateAtZone(Zone(containing:inputPoint.position)) != .Start
    }
    
    override func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        return machine is Mover && (machine as Mover).stateAtZone(Zone(containing: outputPoint.position)) != .End
    }
    
    override func validateConnections() -> Bool {
        var valid = true
        
        let outputCount = outputs().count
        if outputCount != 1 {
            valid = false
            println("Expected \(self) to have 1 output, not \(outputCount)")
        }
        
        let inputCount = inputs().count
        if inputCount < 1 {
            valid = false
            println("Expected \(self) to have at least input, not \(inputCount)")
        }
            
        return valid
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Gameplay Phase
    
    override func update(_dt: CFTimeInterval) {
        
        dequeueAllWidges()
        
        for widge in widgesInState(WaitingToTransfer) {
            connector("output").insert(widge)
        }
    }
    
    // MARK: Debug

    override func description() -> String {
        return "Transfer box at \(originZone)"
    }
}
