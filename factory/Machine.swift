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
    
    var level: Level { return scene as Level }
    
    var originZone: Zone = ZoneZero {  // The most lower-left zone of the machine.
        didSet {
            position = originZone.worldPoint(.SW)
        }
    }
    
    var connectors: [String:Connector] = Dictionary()
    
    init(originZone: Zone) {
        super.init(texture: nil, color: nil, size: CGSizeZero)
        self.anchorPoint = CGPointZero
        self.zPosition = SpriteLayerInFrontOfWidges
        self.originZone = originZone
        position = originZone.worldPoint(.SW)  // :-( no didSet
        
        machineCount++
        self.name = NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last
    }
    
    class func numberOfInitializerParameters() -> Int {
        return 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Phase
    
    func addConnectionPoints() {
        fatalError("addConnectionPoints has not been implemented")
    }
    
    final func addInput(position: CGPoint, name: String, startingState: WidgeState, priority:Int = PriorityLevelHigh) {
        let cp = ConnectionPointIntoMachine(machine: self, position: position, name: name, destinationState: startingState, priority: priority)
        level.connectionPoints.append(cp)
    }
    
    final func addOutput(position: CGPoint, name: String, priority:Int = PriorityLevelHigh) {
        let cp = ConnectionPointOutOfMachine(machine: self, position: position, name: name, priority: priority)
        level.connectionPoints.append(cp)
    }
    
    // MARK: Connection Phase

    func allow(#outputPoint: ConnectionPoint, toConnectToMachine machine: Machine) -> Bool {
        return true // override for advanced decision making
    }
    
    func allow(#inputPoint: ConnectionPoint, toConnectFromMachine machine: Machine) -> Bool {
        return true // override for advanced decision making
    }
    
    // return true if validation passes
    // if something is invalid, println the reason and return false
    func validateConnections() -> Bool {
        
        // Default validation is to require all connection points with high priority
        return requireConnectionsForHighPriorityLevel()
    }
    
    // return true if all high priority level connections were made
    func requireConnectionsForHighPriorityLevel() -> Bool {
        
        var printedHeader = false
        
        let printHeader = { () -> () in
            printedHeader = true
            println("Validation warning: \(self) did not make all required connections.")
        }
        
        for cp in self.connectionPoints() {
            if cp.priority >= PriorityLevelHigh && cp.connector == nil {
                if !printedHeader { printHeader() }
                println("Required connection point \(cp) was not connected")
            }
        }
        
        return !printedHeader
    }
    
    final func connectionPoints() -> [ConnectionPoint] {
        return level.connectionPoints.filter { $0.machine == self }
    }
    
    // MARK: Connector Management
    
    final func inputs() -> [Connector] {
        return connectors.values.array.filter { $0.destination == self }
    }
    
    final func outputs() -> [Connector] {
        return connectors.values.array.filter { $0.source == self }
    }
    
    final func connector(name: String) -> Connector {
        return connectors[name]!
    }
    
    // MARK: Gameplay Phase
    
    func update(_dt: CFTimeInterval) {
        fatalError("update has not been implemented")
        
        // Cycle through connectors, take control of all widges.
        // You may do this in any order.
    }
    
    final func dequeueAllWidges() {
        inputs().map { $0.dequeueWidges() }
    }
    
    // MARK: Widge Management
    
    final func createWidge(type: WidgeType, position: CGPoint, state: WidgeState) -> Widge {
        let newWidge = Widge(widgeType: type)
        newWidge.owner = self
        newWidge.state = state
        newWidge.position = position
        scene!.addChild(newWidge)
        level.widges.append(newWidge)
        return newWidge
    }
    
    final func transform(widge: Widge, toType: WidgeType) -> Widge {
        let count = level.widges.count
        let replacement = createWidge(toType, position: widge.position, state: widge.state)

        deleteWidge(widge)
        assert(level.widges.count == count, "Expected same number of widges after transform \(level.widges.count) as before \(count)")
        return replacement
    }
    
    final func deleteWidge(widge: Widge) {
        assert((widge.owner as Machine) == self, "cannot delete a widge that you do not own")
        
        let count = level.widges.count
        level.widges = level.widges.filter { $0.widgeID != widge.widgeID }
        widge.removeFromParent()
        assert(level.widges.count == count - 1, "Expected one less widge after creating expected=\(count-1) actual=\(level.widges.count)")
    }
    
    final func garbagify(widges: [Widge]) {
        
        if widges.count < 2 {
            return
        }
        
        var rootGarbageLists: [Widge:[Widge]] = [:]
        
        for i in 0 ..< widges.count-1 {
            for j in i+1 ..< widges.count {
                assert(widges[i].widgeID != widges[j].widgeID, "Don't compare to self")
                
                let widge1 = widges[i]
                let widge2 = widges[j]
                
                if widge1.intersectsNode(widge2) {
                    let (priority, other) = widge1.widgeID < widge2.widgeID ? (widge1,widge2) : (widge2,widge1)
                    if !contains(rootGarbageLists.keys, priority) {
                        rootGarbageLists[priority] = []
                    }
                    rootGarbageLists[priority]?.append(other)
                }
            }
        }
        
        for (keep, deleteList) in rootGarbageLists {
            transform(keep, toType: keep.widgeType.garbage)
            deleteList.map{ self.deleteWidge($0) }
        }
    }
    
    final func widges() -> [Widge] {
        return level.widges.filter { ($0.owner as? Machine) == self }
    }
    
    final func widgesInState(state: WidgeState) -> [Widge] {
        return level.widges.filter { (($0.owner as? Machine) == self) && $0.state == state }
    }
    
    // MARK: Debug
    
    func printConnections() {
        println("Connectors for \(self)")
        connectors.values.array.map { println(" -> \($0.destination.name!) at \(Zone(containing:$0.position))") }
    }
    
    func description() -> String {
        return "Machine with origin \(originZone)"
    }
}
