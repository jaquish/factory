//
//  LevelFileParser.swift
//  factory
//
//  Created by Zach Jaquish on 11/19/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

enum ParseStatus {
    case Waiting, InProgress, Failed, Success
}

enum LevelFileSection : String {
    case Unknown  = "@End"
    case Description = "@Description"
    case Metadata = "@Metadata"
    case WidgeTypes = "@WidgeTypes"
    case Actions  = "@Actions"
    case Machines = "@Machines"
    case StaticSprites = "@StaticSprites"
    case Context  = "@Context"
}

var ErrorMessageReason: String! = nil

class LevelFileParser {
    var url: NSURL!
    var level: Level!
    var currentLine = 0
    var currentSection: LevelFileSection = .Unknown
    var status: ParseStatus = .Waiting
    
    init(url: NSURL) {
        self.url = url
    }
    
    convenience init(filename: String) {
        
        var url:NSURL? = nil
        if let filepath = NSBundle.mainBundle().pathForResource(filename, ofType: "level") {
            url = NSURL(fileURLWithPath:filepath)
        } else {
            println("Error: Unable to load level file.")
        }
        self.init(url: url ?? NSURL())
    }
    
    func parseLevel(summaryOnly:Bool = false) -> Level! {
        
        status = .InProgress
        
        println("***** Parsing \(url.lastPathComponent!) *****")
        
        let loadedStringData:NSString! = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)
        
        if loadedStringData != nil {
            
            // Build up this level
            level = Level()
            currentLine = 1
            
            let lines = loadedStringData.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [NSString]
            
            for line in lines {
                
                let line = line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if line.isEmpty || line.hasPrefix("#") {
                    // comment or an empty line, ignore
                } else if line.hasPrefix("@") {
                    processLineSectionChange(line)
                } else {
                    processLineInCurrentSection(line)
                }
                
                if status == .Failed {
                    break
                }
                
                currentLine++
            }
        } else {
            failWithError("Unable to load level file at '\(url.path)")
        }
        
        switch status {
        case .InProgress:
            println("...parsed file successfully. Connecting components...")
            
            let valid = level.makeConnections()
            if (valid) {
                status = .Success
                return level
            } else {
                return nil
            }
        default: return nil
        }
    }
    
    func processLineSectionChange(line: String) {
        if let newSection = LevelFileSection(rawValue: line) {
            currentSection = newSection
        } else {
            failWithError("Choked on unknown section \(line)")
        }
    }
    
    func processLineInCurrentSection(line: String) {
        let parts = line.componentsSeparatedByString({ () -> (String) in
            switch self.currentSection {
                case .Metadata, .Context: return (":")
                default: return " "
            }
        }())
        
        // Verify Count
        let expectedPartsForSection: [LevelFileSection:Int] = [ .Context : 2,
                                                               .Metadata : 2]
        
        let expectedPartsCount = expectedPartsForSection[currentSection] ?? 0
        
        if expectedPartsCount != 0 && parts.count != expectedPartsCount {
            failWithError("Unexpected number of parts (have \(parts.count), expected \(expectedPartsCount))")
            return
        }
        
        // Do Something
        switch currentSection {
        case .Description:
            level.preamble += line + "\n"
        case .Metadata:
            level.metadata[parts[0]] = parts[1]
        case .WidgeTypes:
            if line == "[basic]" {
                let basics = WidgeType.basicWidgeTypes()
                for type in basics {
                    level.registerWidgeType(type)
                }
            } else {
                let widgeType = WidgeType(id: parts[0], spriteName: parts[1], garbage: nil)
                level.registerWidgeType(widgeType)
            }
        case .Actions:
            let actionID = parts[0]
            let actionType = parts[1]
            if actionType == "Combiner" {
                // <id> Combiner <contained-id> <#-required> <success-type> <a:b,c:d,e:f>
                let containedInput = level.widgeType(parts[2])
                let count = parts[3].toInt()!
                let successType = level.widgeType(parts[4])
                let list = parts[5]
                let entries = list.componentsSeparatedByString(",")
                let pairs = entries.map({ ($0.componentsSeparatedByString(":")[0], $0.componentsSeparatedByString(":")[1]) } )
                var mapDict: [WidgeType:WidgeType] = [:]
                for (inputID,outputID) in pairs {
                    let input = level.widgeType(inputID)
                    let output = level.widgeType(outputID)
                    mapDict[input] = output
                }
                
                let action = CombinerAction(ID: actionID, containedInput: containedInput, count: count, successType: successType, mapping: mapDict)
                level.registerAction(action)
            } else if actionType == "Transformer" {
                // <id> Transformer <a:b,c:d,e:f>
                
                let list = parts[2]
                let entries = list.componentsSeparatedByString(",")
                let pairs = entries.map({ ($0.componentsSeparatedByString(":")[0], $0.componentsSeparatedByString(":")[1]) } )
                var mapDict: [WidgeType:WidgeType] = [:]
                for (inputID,outputID) in pairs {
                    let input = level.widgeType(inputID)
                    let output = level.widgeType(outputID)
                    mapDict[input] = output
                }
                
                let action = TransformerAction(ID: actionID, transformMapping: mapDict)
                level.registerAction(action)
            } else {
                failWithError("unable to parse action"); return
            }
            
        case .Machines:

            let machineType = parts[0]
            
            // Assert argument count/types, based on Machine subclass

            var machine: Machine!
            
            switch machineType {
                case "Belt":
                    machine = Belt(from: Zone(parts[1]), thru: Zone(parts[2]), direction: Direction(rawValue: parts[3])!)
                case "Gravity":
                    machine = Gravity(from: Zone(parts[1]), thru: Zone(parts[2]))
                case "Input":
                    if parts.count == 3 {
                        machine = Input(Zone(parts[1]), interval: (parts[2] as NSString).doubleValue)
                    } else {
                        machine = Input(Zone(parts[1]))
                    }
                case "Output":
                    machine = Output(Zone(parts[1]))
                case "TimedTransformer":
                    let action = level.action(parts[2]) as TransformerAction
                    machine = TimedTransformer(Zone(parts[1]), action: action)
                case "Transformer":
                    let action = level.action(parts[2]) as TransformerAction
                    machine = Transformer(Zone(parts[1]), action: action)
                case "TransferBox":
                    machine = TransferBox(Zone(parts[1]))
                case "VerticalBelt":
                    machine = VerticalBelt(from: Zone(parts[1]), thru: Zone(parts[2]), direction: Direction(rawValue:parts[3])!)
                case "SwitchBox":
                    machine = SwitchBox(Zone(parts[1]))
                case "Container":
                    let containedType = level.widgeType(parts[2])
                    machine = Container(Zone(parts[1]), containedType:containedType)
                case "Combiner":
                    let action = level.action(parts[2]) as CombinerAction
                    machine = Combiner(Zone(parts[1]), action:action)
                case "TransportNetwork":
                    let points = parts[1].componentsSeparatedByString(":")
                    let zones = points.map { Zone($0) }
                    machine = TransportNetwork(zones: zones)
                default:
                    failWithError("Unknown class of machine '\(machineType)'"); return
            }
            
            if machine == nil {
                failWithError("Failed to create machine of type \(machineType)"); return
            } else {
                machine.name! += "[\(currentLine)]"
                level.addMachine(machine)
            }
        case .StaticSprites:
            if parts[0] == "coach-direction" {
                let sprite = SKSpriteNode(coachMarkForWidgeType: level.widgeType(parts[1]), direction: Direction(rawValue:parts[2])!)
                sprite.position = Zone(parts[3])^(.center)
                level.addChild(sprite)
            } else if parts[0] == "coach-transformation" {
                let sprite = SKSpriteNode(coachMarkForTransformationFrom: level.widgeType(parts[1]), to: level.widgeType(parts[2]), direction: Direction(rawValue:parts[3])!)
                sprite.position = Zone(parts[4])^(.center)
                level.addChild(sprite)
            }
            
        case .Context:
            let (key,value) = (parts[0], parts[1])
            
            switch key {
                case "inputs":
                    let widgeTypeIDs = parts[1].componentsSeparatedByString(",")
                    level.inputTypes += widgeTypeIDs.map { self.level.widgeType($0) }
                case "winning-outputs":
                    let widgeTypeIDs = parts[1].componentsSeparatedByString(",")
                    level.winning_outputs += widgeTypeIDs.map { self.level.widgeType($0) }
                case "input-order":
                    level.inputOrder = InputOrder(rawValue: value)!
                case "endgame-output-count":
                    level.endgame_output_count = parts[1].toInt()!
                default:
                    failWithError("Unknown context key '\(key)"); return
            }
        case .Unknown:
            failWithError("Trying to parse line in unknown section."); return
        }
    }
    
    // MARK: Logging
    
    func logInfo(info: String) {
        println(info)
    }
    
    func failWithError(message: String) {
        status = .Failed
        let reason = ErrorMessageReason ?? "none given"
        println("[\(url.lastPathComponent!)][line \(currentLine)][ERROR] \(message) Reason:\(ErrorMessageReason)")
    }
    
    func logWarning(reason: String) {
        println("[line \(currentLine)] Parsing warning: " + reason)
    }
}
