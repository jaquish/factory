//
//  LevelFileParser.swift
//  factory
//
//  Created by Zach Jaquish on 11/19/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

enum LevelFileSection : String {
    case Unknown  = "@End"
    case Description = "@Description"
    case Metadata = "@Metadata"
    case Widges   = "@Widges"
    case Actions  = "@Actions"
    case Machines = "@Machines"
    case Context  = "@Context"
}

class LevelFileParser {
    var url: NSURL!
    var currentLine = 0
    var currentSection: LevelFileSection = .Unknown
    var level:Level!
    
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
    
    func parseLevel() -> Level {
        
        let loadedStringData:NSString! = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)
        
        if loadedStringData == nil {
            failWithError("Error: Unable to load level file at '\(url.path)")
        }
        
        level = Level()
        widgeTypes.removeAll()
        currentLine = 1
        
        let lines = loadedStringData.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [NSString]
        for (lineNumber, line) in enumerate(lines) {
            currentLine = lineNumber
            let line = line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if line.isEmpty || line.hasPrefix("#") {
                // comment or an empty line, ignore
            } else if line.hasPrefix("@") {
                processLineSectionChange(line)
            } else {
                processLineInCurrentSection(line)
            }
        }
        
        return level
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
        let expectedPartsCount = { () -> Int in
            switch self.currentSection {
            case .Context:  return 2
            case .Metadata: return 2
            case .Actions:  return 5
            case .Widges:   return 0
            default: return 0
            }
        }()
        
        if expectedPartsCount != 0 && parts.count != expectedPartsCount {
            failWithError("Unexpected number of parts (have \(parts.count), expected \(expectedPartsCount))")
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
            level.actions[name] = Action(actionID: name, actionType: actionType, inputTypeIDs: inputIDs, successTypeIDs: successIDs, failureTypeIDs: failureIDs)
        case .Machines:

            let machineType = parts[0]
            
            // Assert argument count/types, based on Machine subclass

            switch machineType {
                case "Belt":
                    level.machines.append(Belt(from: Zone(parts[1]), thru: Zone(parts[2]), direction: Direction(rawValue: parts[3])!))
                case "Gravity":
                    level.machines.append(Gravity(from: Zone(parts[1]), thru: Zone(parts[2])))
                case "Input":
                    level.inputMachine = Input(Zone(parts[1]))
                    level.machines.append(level.inputMachine)
                case "Output":
                    level.machines.append(Output(Zone(parts[1])))
                case "Transformer":
                    let action = level.actions[parts[2]]!
                    level.machines.append(Transformer(Zone(parts[1]), action: action))
                case "TransferBox":
                    level.machines.append(TransferBox(Zone(parts[1])))
                case "VerticalBelt":
                    level.machines.append(VerticalBelt(from: Zone(parts[1]), thru: Zone(parts[2]), direction: Direction(rawValue:parts[3])!))
                default:
                    failWithError("Unknown class of machine '\(machineType)'")
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
                    failWithError("Unknown context key '\(key)")
            }
        case .Unknown:
            failWithError("Trying to parse line in unknown section.")
        }
    }
    
    // MARK: Logging
    
    func logInfo(info: String) {
        println(info)
    }
    func failWithError(reason: String) {
        println("[line \(currentLine)] Parsing failed: " + reason)
    }
    
    func logWarning(reason: String) {
        println("[line \(currentLine)] Parsing warning: " + reason)
    }
}
