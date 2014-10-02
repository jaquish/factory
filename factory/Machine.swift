//
//  Machine.swift
//  factory
//
//  Created by Zach Jaquish on 11/5/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class Machine: SKSpriteNode {

    var originZone: FGZone = FGZoneZero {  // The most lower-left zone of the machine.
        didSet {
            position = compassPointOfZone(.SW, originZone)
        }
    }
    
    var connectionPointInputs: [ConnectionPoint] = Array()
    var connectionPointOutputs: [ConnectionPoint] = Array()
    var connectors: [String:Connector] = Dictionary()
    
    init(originZone: FGZone) {
        super.init(texture: nil, color: nil, size: CGSizeZero)
        self.anchorPoint = CGPointZero
        self.zPosition = SpriteLayerInFrontOfWidges
        self.originZone = originZone
        position = compassPointOfZone(.SW, originZone)  // :-( no didSet
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_dt: CFTimeInterval) {
         // Do something
    }
    
    func propogate() {
        // Do something
    }
    
    func organizeConnectors() {
        println("Connectors for \(name!)")
        for cp in (connectionPointInputs + connectionPointOutputs) {
            if let connector = cp.connector {
                connectors[cp.name] = cp.connector
                println("-- \(cp.name)")
            }
        }
    }
    
    func addInput(cp: ConnectionPoint) {
        cp.machine = self
        assert(cp.name.length > 0, "Connection point should have a name.")
        connectionPointInputs.append(cp)
    }
    
    func addOutput(cp: ConnectionPoint) {
        cp.machine = self
        assert(cp.name.length > 0, "Connection point should have a name.")
        connectionPointOutputs.append(cp)
    }
    
    func addSimpleInput(name: String) {
        let cp = ConnectionPoint(position: centerOf(originZone), name: name)
        self.addInput(cp)
    }
    
    func addSimpleOutput(name: String) {
        let cp = ConnectionPoint(position: centerOf(originZone), name: name)
        self.addOutput(cp)
    }

    func connectorWithName(name: String) -> Connector {
        return connectors[name]!
    }
    
    func inputs() -> [Connector] {
        return connectors.values.array.filter { $0.destination == self }
    }
    
    func outputs() -> [Connector] {
        return connectors.values.array.filter { $0.source == self }
    }
    
    func allowConnectionWith(machine: Machine) -> Bool {
        return true // override for advanced decision making

    }
    
    func description() -> String {
        return "\(name) at \(originZone)"
    }
}
