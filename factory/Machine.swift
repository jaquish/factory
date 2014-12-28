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

// Global States
typealias WidgeState = String
let MarkedForDeletion: WidgeState = "MarkedForDeletion"

class Machine: SKSpriteNode, LevelFileObject {
    
    var originZone: Zone = ZoneZero {  // The most lower-left zone of the machine.
        didSet {
            position = originZone.worldPoint(.SW)
        }
    }
    
    var connectionPointInputs: [ConnectionPointDestination] = Array()
    var connectionPointOutputs: [ConnectionPointSource] = Array()
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
        
        // Cycle through connectors, take control of all widges.
        // You may do this in any order.
    }

    func propogate() {
        fatalError("propogate has not been implemented")
    }
    
    func organizeConnectors() {
//        println("Connectors for \(self)")
//        for cp in (connectionPointInputs + connectionPointOutputs) {
//            if let connector = cp.connector {
//                connectors[cp.name] = cp.connector
//                println("-- \(cp.name)")
//            }
//        }
        didMakeConnections()
    }
    
    // MARK: Setup Phase
    
    func addInput(position: CGPoint, name: String, startingState: WidgeState, priority:Int = 1) {
        let cp = ConnectionPointDestination(machine: self, position: position, name: name, destinationState: startingState)
        connectionPointInputs.append(cp)
    }
    
    func addOutput(position: CGPoint, name: String, priority:Int = 1) {
        let cp = ConnectionPointSource(machine: self, position: position, name: name)
        connectionPointOutputs.append(cp)
    }
    
    // MARK: Connection Phase

    func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        return true // override for advanced decision making
    }
    
    func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        return true // override for advanced decision making
    }
    
    func didMakeConnections() {
        // do nothing
    }
    
    // MARK: Running Phase
    
    func inputs() -> [Connector] {
        return connectors.values.array.filter { $0.destination == self }
    }
    
    func outputs() -> [Connector] {
        return connectors.values.array.filter { $0.source == self }
    }
    
    func connectorWithName(name: String) -> Connector {
        return connectors[name]!
    }
    
    func dequeueAllWidges() {
        inputs().map { $0.dequeueWidges() }
    }
    
    // MARK: Widge Management
    
    func createWidge(type: String, position: CGPoint, state: WidgeState) -> Widge {
        let replacement = CurrentLevel.createWidge(type)
        replacement.position = position
        scene?.addChild(replacement)
        return replacement
    }
    
    func transform(widge: Widge, toType: String) -> Widge {
        let replacement = createWidge(toType, position: widge.position, state: widge.state)
        deleteWidge(widge)
        return replacement
    }
    
    func transformToGarbage(widges: [Widge]) {
        // TODO
    }
    
    func deleteWidge(widge: Widge) {
        AllWidges = AllWidges.filter { $0 != widge }
        widge.removeFromParent()
    }
    
    func widges() -> [Widge] {
        return AllWidges.filter { ($0.owner as? Machine) == self }
    }
    
    func widgesInState(state: WidgeState) -> [Widge] {
        return AllWidges.filter { (($0.owner as? Machine) == self) && $0.state == state }
    }
    
    // MARK: Debug
    
    func description() -> String {
        return "\(name!) at \(originZone)"
    }
}
