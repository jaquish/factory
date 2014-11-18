//
//  Level.swift
//  factory
//
//  Created by Zach Jaquish on 11/12/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

enum ParseSection {
    case Unknown, Metadata, Widges, Actions, Machines, Context
}

class Level: NSObject {
   
    var section: ParseSection = .Unknown

    var inputMachine: Input!
    var inputWidgeTypes  = [String]()
    var outputWidgeTypes = [String]()
    
    var widgeTypes = [String : String]()
    var actions = [String : Action]()

    var machines: [Machine] = Array()
    
    var metadata = [String : AnyObject]()
    
    var outputs = [String : Int]()
    var endgame_output_count: Int = 0
    
    init(filepath: NSURL) {
        super.init()
        
        let stringData = NSString(contentsOfURL: filepath, encoding: NSUTF8StringEncoding, error: nil)
        
        for line in stringData?.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String] {
            
            // Use # to mark comments. Empty lines (all whitespace) are also ignored.
            if line.hasPrefix("#") ||
               line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty {
                continue
            }
            if line.hasPrefix("@Metadata") {
                section = .Metadata
                continue
            } else if line.hasPrefix("@Machines") {
                section = .Machines
                continue
            } else if line.hasPrefix("@Widges") {
                section = .Widges
                continue
            } else if line.hasPrefix("@Context") {
                section = .Context
                continue
            } else if line.hasPrefix("@Actions") {
                section = .Actions
                continue
            }
            
            switch section {
            case .Metadata:
                let parts = line.componentsSeparatedByString(":") as [String]
                assert(parts.count == 2, "Expected key and value for metadata")
                let key = parts[0]
                let value = parts[1]
                metadata[key] = value
                
            case .Widges:
                if line == "[basic]" {
                    register("red",     spriteName: "$\(UIColor.redColor().toString())")
                    register("orange",  spriteName: "$\(UIColor.orangeColor().toString())")
                    register("yellow",  spriteName: "$\(UIColor.yellowColor().toString())")
                    register("green",   spriteName: "$\(UIColor.greenColor().toString())")
                    register("blue",    spriteName: "$\(UIColor.blueColor().toString())")
                    register("purple",  spriteName: "$\(UIColor.purpleColor().toString())")
                    break
                }
                
                let parts = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as [String]
                assert(parts.count == 2, "Not the right amount of arguments")
            
                
            case .Actions:
                
                let parts = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as [String]
                assert(parts.count == 4, "Not the right amount of arguments")
                
                let name = parts[0]
                let actionType = ActionType(rawValue: parts[1])!
                let inputIDs = parts[1].componentsSeparatedByString(",")
                let successIDs = parts[2].componentsSeparatedByString(",")
                let failureIDs = parts[3].componentsSeparatedByString(",")
                
                self.actions[name] = Action(actionID: name, actionType: actionType, inputTypeIDs: inputIDs, successTypeIDs: successIDs, failureTypeIDs: failureIDs)
                
                break;
                
            case .Machines:
                let parts = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as [String]
                
                let machineType = parts[0]
                
                if machineType == "Belt" {
                    assert(parts.count == 3, "Not the right amount of arguments")
                    machines.append(Belt(from: Zone(parts[1]), thru: Zone(parts[2])))
                    
                } else if machineType == "Gravity" {
                    assert(parts.count == 3, "Not the right amount of arguments")
                    machines.append(Gravity(from: Zone(parts[1]), thru: Zone(parts[2])))
                    
                } else if machineType == "Input" {
                    assert(parts.count == 2, "Not the right amount of arguments")
                    inputMachine = Input(Zone(parts[1]))
                    machines.append(inputMachine)
                    
                } else if machineType == "Output" {
                    assert(parts.count == 2, "Not the right amount of arguments")
                    machines.append(Output(Zone(parts[1])))
                    
                } else if machineType == "Transformer" {
                    assert(parts.count == 4, "Not the right amount of arguments")
                    
                    let action = actions[parts[3]]!
                    machines.append(Transformer(Zone(parts[1]), color:UIColor(parts[2]), action: action))
                    
                } else if machineType == "TransferBox" {
                    assert(parts.count == 2, "Not the right amount of arguments")
                    machines.append(TransferBox(Zone(parts[1])))
                    
                } else if machineType == "VerticalBelt" {
                    assert(parts.count == 3, "Not the right amount of arguments")
                    machines.append(VerticalBelt(from: Zone(parts[1]), thru: Zone(parts[2])))
                }
                
            case .Context:
                let parts = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as [String]
                
                if parts[0].hasPrefix("inputs") {
                    let widgeTypeIDs = parts[1].componentsSeparatedByString(",")
                    inputWidgeTypes += widgeTypeIDs
                    
                } else if parts[0].hasPrefix("winning-outputs") {
                    let widgeTypeIDs = parts[1].componentsSeparatedByString(",")
                    outputWidgeTypes += widgeTypeIDs
                    
                } else if parts[0].hasPrefix("endgame-output-count") {
                    endgame_output_count = parts[1].toInt()!
                }

            default:
                break;
            }
        }
    }
    
    convenience init(_ n: Int) {
        self.init(filepath: NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("level\(n)", ofType: "level")!)!)
    }
    
    func summary() -> String {
        var summary = ""
        for (key, value) in metadata {
            summary += "\(key) : \(value)\n"
        }
        return summary
    }
    
    func register(typeName:String, spriteName:String) {
        widgeTypes[typeName] = spriteName
    }
    
    func createWidge(widgeTypeID: String) -> Widge {
        var spriteName = widgeTypes[widgeTypeID]!
        if spriteName.hasPrefix("$") {
            spriteName = spriteName.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "$"))
            return Widge.widgeWith(widgeTypeID, color: UIColor(spriteName))
        } else {
            println("Warning! not ready to process")
            return Widge.redWidge()
        }
    }
    
    func createInput() -> Widge {
        return createWidge(inputWidgeTypes.randomItem())
    }
    
    func isGameOver() -> Bool {
        return outputs.values.array.reduce(0,+) >= endgame_output_count
    }
    
    func addOutput(widgeTypeID: String) {
        if (outputs[widgeTypeID] == nil) {
            outputs[widgeTypeID] = 0
        }
        outputs[widgeTypeID] = outputs[widgeTypeID]! + 1
    }
}

extension UIColor {
    func toString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        return "\(r),\(g),\(b)"
    }
    
    convenience init(_ string: String) {
        let stringParts = string.componentsSeparatedByString(",") as [String]
        let floatParts = stringParts.map { CGFloat(($0 as NSString).floatValue) }
        assert(floatParts.count == 3)
        self.init(red:floatParts[0], green: floatParts[1], blue: floatParts[2], alpha: 1.0)
    }
}
