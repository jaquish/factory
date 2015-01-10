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
    var machines: [Machine] = Array()
    var level:Level!

    override init(size: CGSize) {
        
        _prevTime = 0
        _dt = 0
        
        super.init(size: size)
        
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
    }
    
    func loadLevel(level: Level) -> Bool {
        AllWidges.removeAll()
        self.level = level
    
        addMachines(level.machines)
        let valid = level.makeConnections()
        return valid
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMachine(machine: Machine) {
        println("+ added machine \(machine)")
        machines.append(machine)
        addChild(machine)
    }
    
    func addMachines(machines: [Machine]) {
        machines.map { self.addMachine($0) }
    }
    
    override func update(currentTime: NSTimeInterval) {
        /* Called before each frame is rendered */
        _dt = currentTime - _prevTime;
        
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
}



