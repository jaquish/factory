//
//  Machine.swift
//  factory
//
//  Created by Zach Jaquish on 11/5/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

var machineCount = 0

class Machine: SKSpriteNode, LevelFileObject {
        
    var originZone: Zone = ZoneZero {  // The most lower-left zone of the machine.
        didSet {
            position = originZone.worldPoint(.SW)
        }
    }
    
    var connectionPointInputs: [ConnectionPoint] = Array()
    var connectionPointOutputs: [ConnectionPoint] = Array()
    var connectors: [String:Connector] = Dictionary()
    
    init(originZone: Zone) {
        super.init(texture: nil, color: nil, size: CGSizeZero)
        self.anchorPoint = CGPointZero
        self.zPosition = SpriteLayerInFrontOfWidges
        self.originZone = originZone
        position = originZone.worldPoint(.SW)  // :-( no didSet
        
        machineCount++
        self.name = "\(NSStringFromClass(self.dynamicType))-\(machineCount)"
    }
    
    class func numberOfInitializerParameters() -> Int {
        return 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_dt: CFTimeInterval) {
         fatalError("update has not been implemented")
    }
    
    func propogate() {
        fatalError("propogate has not been implemented")
    }
    
    func organizeConnectors() {
        println("Connectors for \(self)")
        for cp in (connectionPointInputs + connectionPointOutputs) {
            if let connector = cp.connector {
                connectors[cp.name] = cp.connector
                println("-- \(cp.name)")
            }
        }
        didMakeConnections()
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
        let cp = ConnectionPoint(position: originZone.worldPoint(.center), name: name)
        self.addInput(cp)
    }
    
    func addSimpleOutput(name: String) {
        let cp = ConnectionPoint(position: originZone.worldPoint(.center), name: name)
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
    
    func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        return true // override for advanced decision making
    }
    
    func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        return true // override for advanced decision making
    }
    
    func didMakeConnections() {
        // do nothing
    }
    
    func description() -> String {
        return "\(name!) at \(originZone)"
    }
}
