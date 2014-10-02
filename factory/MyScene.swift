//
//  MyScene.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class MyScene: SKScene {
   
    var _prevTime: CFTimeInterval
    var _dt: CFTimeInterval
    var machines: [Machine]
    
    /* Temporary direct links */
    var input: Input?

    override init(size: CGSize) {
        
        _prevTime = 0
        _dt = 0
        machines = Array()
        
        super.init(size: size)
        
        self.machines = Array()
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        input = Input(originZone: FGZoneMake(2, 8))
        input!.name = "input"
        addMachine(input!)
        
        let gravity = Gravity(originZone: FGZoneMake(2, 8), endZone: FGZoneMake(2, 2))
        gravity.name = "gravity1"
        addMachine(gravity)
        
        let belt = Belt(originZone: FGZoneMake(2, 2), endZone: FGZoneMake(7, 2))
        belt.name = "belt"
        addMachine(belt)
        
        let transformer = Transformer(originZone: FGZoneMake(4, 2), color: UIColor.yellowColor())
        transformer.name = "transformer"
        addMachine(transformer)
        
        let transformer2 = Transformer(originZone: FGZoneMake(6, 2), color: UIColor.greenColor())
        transformer2.name = "transformer-2"
        addMachine(transformer2)

        let transferBox = TransferBox(originZone: FGZoneMake(8, 2))
        transferBox.name = "transfer-box"
        addMachine(transferBox)
        
        let transferBox2 = TransferBox(originZone: FGZoneMake(8, 7))
        transferBox2.name = "transfer-box-2"
        addMachine(transferBox2)
        
        let verticalBelt = VerticalBelt(originZone: FGZoneMake(8, 2), endZone: FGZoneMake(8, 7))
        verticalBelt.name = "vertical"
        addMachine(verticalBelt)
        
        let belt2 = Belt(originZone: FGZoneMake(8,7), endZone: FGZoneMake(11,7))
        belt2.name = "belt-2"
        addMachine(belt2)
        
        let gravity2 = Gravity(originZone: FGZoneMake(12,7), endZone: FGZoneMake(12,0))
        gravity2.name = "gravity2"
        addMachine(gravity2)
        
        let output = Output(originZone: FGZoneMake(12, 0))
        output.name = "output"
        addMachine(output)
        
        makeConnections()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMachine(machine: Machine) {
        println("added machine \(machine.name) at \(machine.position)")
        machines.append(machine)
        addChild(machine)
    }
    
    func makeConnections() {
        let sorter = NSSortDescriptor(key: "priority", ascending: false)
        
        // get outputs in sorted priority order
        var allOutputs = [ConnectionPoint]()
        for machine in machines {
            allOutputs += machine.connectionPointOutputs
        }
        allOutputs.sort {$0.priority > $1.priority }
        
        // get outputs in sorted priority order
        var allInputs = [ConnectionPoint]()
        for machine in machines {
            allInputs += machine.connectionPointInputs
        }
        allInputs.sort {$0.priority > $1.priority }
        
        // shotgun connections
        for output in allOutputs {
            for input in allInputs {
                output.tryToConnectToPoint(input)
            }
        }
        
        for machine in machines {
            machine.organizeConnectors()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        input?.generateWidge()
    }
    
    override func update(currentTime: NSTimeInterval) {
        /* Called before each frame is rendered */
        _dt = currentTime - _prevTime;
        
        for machine in machines {
            machine.update(_dt)
        }
        
        // propogate
        for machine in machines {
            for connector in machine.connectors.values {
                connector.propogate()
            }
        }
        
        /*** TODO - insert phase 2 processing here ***/
        
        _prevTime = currentTime;
    }
}



