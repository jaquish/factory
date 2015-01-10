//
//  SwitchBox.swift
//  factory
//
//  Created by Zach Jaquish on 11/27/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let WaitingToTransfer: WidgeState = "WaitingToTransfer"

class SwitchBox: Machine {
    
    var labelNode:SKLabelNode!
    var selectedOutput:Connector! {
        didSet {
            if let beltOutput = selectedOutput.destination as? Belt {
                labelNode.text = labelForDirection(beltOutput.direction)
            } else if let beltOutput = selectedOutput.destination as? VerticalBelt  {
                labelNode.text = labelForDirection(beltOutput.direction)
            } else if let gravityOutput = selectedOutput.destination as? Gravity {
                labelNode.text = labelForDirection(.S)
            } else {
                fatalError("Unable to process connection to output machine")
            }
        }
    }
    
    var outputList:[Connector]!

    init(_ originZone: Zone) {
        super.init(originZone: originZone)
        zPosition = SpriteLayerInFrontOfWidges
        
        addChild(Util.zoneBoxWithBorder(UIColor.darkGrayColor(), innerColor: UIColor.grayColor()))
        
        labelNode = SKLabelNode()
        labelNode.verticalAlignmentMode = .Center
        labelNode.position = ZoneZero.worldPoint(.center)
        labelNode.fontSize = LabelFontSize * 2
        addChild(labelNode)
        
        for i in 0..<2 {
            addInput(originZone^(.center), name: "input-\(i)", startingState: WaitingToTransfer)
            addOutput(originZone^(.center), name: "output-\(i)")
        }

        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // toggle output
        let currentIndex = find(outputs(), selectedOutput)!
        selectedOutput = outputs()[(currentIndex + 1) % outputs().count]
    }
    
    override func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        return (machine is Belt) || (machine is VerticalBelt)
    }
    
    override func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        return (machine is Belt) || (machine is VerticalBelt) || (machine is Gravity)
    }
    
    func labelForDirection(d:Direction) -> String {
        switch d {
        case .N:  return "⬆️"
        case .NE: return "↗️"
        case .E:  return "➡️"
        case .SE: return "↘️"
        case .S:  return "⬇️"
        case .SW: return "↙️"
        case .W:  return "⬅️"
        case .NW: return "↖️"
        case .center: fatalError("Invalid output direction for transfer box")
        }
    }

    override func validateConnections() -> Bool {
        
        var  valid = true
        outputList = outputs()
        
        let outputCount = outputs().count
        if outputCount < 2 {
            valid = false
            println( "Expected switchbox to have at least 2 outputs, not \(outputCount)")
        }
        
        let inputCount = inputs().count
        if inputCount < 1 {
            valid = false
            println ("Expected switchbox to have at least 1 input, not \(inputCount)")
        }
        
        selectedOutput = outputList.first!
        
        return valid
    }
    
    override func update(_dt: CFTimeInterval) {
        
        dequeueAllWidges()
        
        // stick input into the output connector
        for widge in widgesInState(WaitingToTransfer) {
            selectedOutput.insert(widge)
        }
    }
    
    override func description() -> String {
        let inputDirections = inputs().map { ($0.source as Mover).movingDirection().rawValue }
        let outputDirections = outputs().map { ($0.destination as Mover).movingDirection().rawValue }
        return "SwitchBox at \(originZone) inputDirections=\(inputDirections) outputDirections=\(outputDirections)"
    }
}
