//
//  MyScene.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class LevelScene: SKScene {
   
    var _prevTime: CFTimeInterval
    var _dt: CFTimeInterval
    var machines: [Machine]
    
    /* Temporary direct links */
    var input: Input?

    override init(size: CGSize) {
        
        _prevTime = 0
        _dt = 0
        machines = Array()
        
        machineCount = 0
        
        super.init(size: size)
        
        self.machines = Array()
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        
        loadLevel(Level(1))
    }
    
    func loadLevel(level: Level) {
        input = level.input
        addMachines(level.machines)
        makeConnections()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMachine(machine: Machine) {
        println("added machine \(machine)")
        machines.append(machine)
        addChild(machine)
    }
    
    func addMachines(machines: [Machine]) {
        machines.map { self.addMachine($0) }
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


