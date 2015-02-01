//
//  MyScene.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

enum InputOrder : String {
    case Linear = "linear"
    case Random = "random"
}

var CurrentLevel: Level!

var AllWidges: [Widge] = []

class Level: SKScene {
   
    // Level Description
    var preamble = String()
    
    // Setup
    
    var metadata: [String : AnyObject] = [:]
    
    let widgeGraphManager:WidgeGraphManager = WidgeGraphManager()
    
    var inputTypes: [WidgeType] = []
    var machines: [Machine] = []
    
    // TODO: Refactor to per-machine basis
    var inputIndex = 0
    var inputOrder:InputOrder = .Linear
    
    // Gameplay Phase
    var _prevTime: CFTimeInterval
    var _dt: CFTimeInterval
    
    var outputs:[WidgeType] = []
    var endgame_output_count: Int = 0
    
    var connectionPoints = [ConnectionPoint]()
    
    override convenience init() {
        self.init(size: CGSizeZero)
    }
    override init(size: CGSize) {
        
        _prevTime = 0
        _dt = 0
        
        super.init(size: size)
        
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMachine(machine: Machine) {
        println("+ \(machine.name!) \(machine)")
        machines.append(machine)
        addChild(machine)
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        /* Called before each frame is rendered */
        _dt = currentTime - _prevTime;
        
        if _dt > 1 {
            println("Interval too large, resetting to 1/60 s")
            _dt = 1.0/60.0
        }
        
        for machine in machines {
            machine.update(_dt)
        }
        
        // propogate
        
        for machine in machines {
            machine.inputs().map { $0.propogate() }
        }
        
        /*** TODO - insert phase 2 processing here ***/
        
        _prevTime = currentTime;
    }
    
    
    func summary() -> String {
        var summary = ""
        for (key, value) in metadata {
            summary += "\(key) : \(value)\n"
        }
        summary += "\n\n" + preamble
        return summary
    }
    
    func nextInputType() -> WidgeType {
        inputIndex++
        switch inputOrder {
        case .Random: return inputTypes.randomItem()
        case .Linear: return inputTypes[(inputIndex-1) % inputTypes.count]
        }
    }
    
    func isGameOver() -> Bool {
        return outputs.count >= endgame_output_count
    }
    
    func addOutput(widgeType: WidgeType) {
        outputs.append(widgeType)
    }
    
    // MARK: Connection Phase
    
    func makeConnections() -> Bool {
        
        // priority order
        var outputs = connectionPoints.filter { $0 is ConnectionPointOutOfMachine } as [ConnectionPointOutOfMachine]
        outputs.sort {$0.priority > $1.priority }
        
        // Bucket connections into points
        for output in outputs {
            let inputsAtSamePoint = connectionPoints.filter { $0 is ConnectionPointIntoMachine && CGPointEqualToPoint(output.position,$0.position) } as [ConnectionPointIntoMachine]
            output.tryToConnectToOneOf(inputsAtSamePoint)
        }
        
        for cp in connectionPoints {
            if let connector = cp.connector {
                cp.machine.connectors[cp.name] = cp.connector
            }
        }
        
        var allConnectionsValid = true
        for machine in machines {
            machine.printConnections()
            let valid = machine.validateConnections()
            if !valid {
                allConnectionsValid = false
            }
        }
        
        return allConnectionsValid
    }
}
