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
let Created: WidgeState = "Created"
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
    
    // MARK: Setup Phase
    
    func addInput(position: CGPoint, name: String, startingState: WidgeState, priority:Int = 1, isRequired: Bool = true) {
        let cp = ConnectionPointDestination(machine: self, position: position, name: name, destinationState: startingState, priority: priority, isRequired: isRequired)
        connectionPointInputs.append(cp)
    }
    
    func addOutput(position: CGPoint, name: String, priority:Int = 1, isRequired: Bool = true) {
        let cp = ConnectionPointSource(machine: self, position: position, name: name, priority: priority, isRequired: isRequired)
        connectionPointOutputs.append(cp)
    }
    
    // MARK: Connection Phase

    func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        return true // override for advanced decision making
    }
    
    func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        return true // override for advanced decision making
    }
    
    func organizeConnectors() {
        for cp in (connectionPointInputs as [ConnectionPoint] + connectionPointOutputs as [ConnectionPoint]) {
            if let connector = cp.connector {
                connectors[cp.name] = cp.connector
            }
        }
        println("Connectors for \(self)")
        connectors.keys.array.map { println("-- \($0)") }
        validateConnections()
    }
    
    func validateConnections() {
        var printedHeader = false
        
        let printHeader = { () -> () in
            printedHeader = true
            println("Validation warning: \(self) did not make all required connections.")
        }
        
        for cp in connectionPointInputs as [ConnectionPoint] + connectionPointOutputs as [ConnectionPoint] {
            if cp.isRequired && cp.connector == nil {
                if !printedHeader { printHeader() }
                println("Required connection point \(cp) was not connected")
            }
        }
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
        let count = AllWidges.count
        let newWidge = CurrentLevel.createWidge(type)
        newWidge.owner = self
        newWidge.state = state
        newWidge.position = position
        scene?.addChild(newWidge)
        assert(AllWidges.count == count + 1, "Expected one more widge after creating expected=\(count+1) actual=\(AllWidges.count)")
        return newWidge
    }
    
    func transform(widge: Widge, toType: String) -> Widge {
        let count = AllWidges.count
        let replacement = createWidge(toType, position: widge.position, state: widge.state)

        deleteWidge(widge)
        assert(AllWidges.count == count, "Expected same number of widges after transform \(AllWidges.count) as before \(count)")
        return replacement
    }
    
    func transformToGarbage(widges: [Widge]) {
        // TODO
    }
    
    func deleteWidge(widge: Widge) {
        assert((widge.owner as Machine) == self, "cannot delete a widge that you do not own")
        
        let count = AllWidges.count
        AllWidges = AllWidges.filter { $0.widgeID != widge.widgeID }
        widge.removeFromParent()
        assert(AllWidges.count == count - 1, "Expected one less widge after creating expected=\(count-1) actual=\(AllWidges.count)")
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
