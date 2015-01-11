//
//  LevelFileParser.swift
//  factory
//
//  Created by Zach Jaquish on 11/19/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

enum ParseStatus {
    case Waiting, InProgress, Failed, Success
}

enum LevelFileSection : String {
    case Unknown  = "@End"
    case Description = "@Description"
    case Metadata = "@Metadata"
    case Widges   = "@Widges"
    case Actions  = "@Actions"
    case Machines = "@Machines"
    case Context  = "@Context"
}

var ErrorMessageReason: String! = nil

class LevelFileParser {
    var url: NSURL!
    var currentLine = 0
    var currentSection: LevelFileSection = .Unknown
    var level:Level!
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
    
    func parseLevel() -> Level! {
        
        status = .InProgress
        
        println("***** Parsing \(url.lastPathComponent!) *****")
        
        let loadedStringData:NSString! = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)
        
        if loadedStringData != nil {
            
            level = Level()
            CurrentLevel = level
            widgeTypes.removeAll()
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
            println("....file appears to be valid. Loading level components...")
            status = .Success
            return level
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
                                                               .Metadata : 2,
                                                                .Actions : 5,
                                                                 .Widges : 0];
        
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
        case .Widges:
            if line == "[basic]" {
                Widge.registerBasicWidges()
            }
        case .Actions:
            let name = parts[0]
            let actionType = ActionType(rawValue: parts[1])!
            let inputIDs = parts[2].componentsSeparatedByString(",")
            let successIDs = parts[3].componentsSeparatedByString(",")
            let failureIDs = parts[4].componentsSeparatedByString(",")
            level.actions[name] = Action.actionWith(actionType, actionID: name, inputTypeIDs: inputIDs, successTypeIDs: successIDs, failureTypeIDs: failureIDs)
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
                case "Transformer":
                    let action = level.actions[parts[2]]! as TransformAction
                    machine = Transformer(Zone(parts[1]), action: action)
                case "TransferBox":
                    machine = TransferBox(Zone(parts[1]))
                case "VerticalBelt":
                    machine = VerticalBelt(from: Zone(parts[1]), thru: Zone(parts[2]), direction: Direction(rawValue:parts[3])!)
                case "SwitchBox":
                    machine = SwitchBox(Zone(parts[1]))
                case "Container":
                    machine = Container(Zone(parts[1]), containedType:parts[2])
                case "Combiner":
                    let action = level.actions[parts[2]]! as CombinationAction
                    machine = Combiner(Zone(parts[1]), action:action)
                default:
                    failWithError("Unknown class of machine '\(machineType)'"); return
            }
            
            if machine == nil {
                failWithError("Failed to create machine of type \(machineType)"); return
            } else {
                machine.name! += "[\(currentLine)]"
                level.machines.append(machine)
            }
            
        case .Context:
            let (key,value) = (parts[0], parts[1])
            
            switch key {
                case "inputs":
                    let widgeTypeIDs = parts[1].componentsSeparatedByString(",")
                    level.inputWidgeTypes += widgeTypeIDs
                case "winning-outputs":
                    let widgeTypeIDs = parts[1].componentsSeparatedByString(",")
                    level.outputWidgeTypes += widgeTypeIDs
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
