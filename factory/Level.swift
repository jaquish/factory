//
//  Level.swift
//  factory
//
//  Created by Zach Jaquish on 11/12/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

enum ParseSection {
    case Unknown, Metadata, Machines, Widges, Context, Actions
}

class Level: NSObject {
   
    var section: ParseSection = .Unknown

    var input: Input!
    var machines: [Machine] = Array()
    
    var metadata = [String : AnyObject]()
    
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
                    input = Input(Zone(parts[1]))
                    machines.append(input)
                    
                } else if machineType == "Output" {
                    assert(parts.count == 2, "Not the right amount of arguments")
                    machines.append(Output(Zone(parts[1])))
                    
                } else if machineType == "Transformer" {
                    assert(parts.count == 3, "Not the right amount of arguments")
                    machines.append(Transformer(Zone(parts[1]), color:UIColor(parts[2])))
                    
                } else if machineType == "TransferBox" {
                    assert(parts.count == 2, "Not the right amount of arguments")
                    machines.append(TransferBox(Zone(parts[1])))
                    
                } else if machineType == "VerticalBelt" {
                    assert(parts.count == 3, "Not the right amount of arguments")
                    machines.append(VerticalBelt(from: Zone(parts[1]), thru: Zone(parts[2])))
                }
                
            case .Widges:
                if line == "[default]" {
                    // register default set
                    break
                }
                
                let parts = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as [String]
                
            case .Context:
                let parts = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as [String]
                
                if parts[0].hasPrefix("inputs") {
                    let widgeIDs = parts[1].componentsSeparatedByString(",")
                    // mark widge as input
                    
                } else if parts[0].hasPrefix("winning-outputs") {
                    let widgeIDs = parts[1].componentsSeparatedByString(",")
                    // mark widge as output
                }
                
            case .Actions:
                break;
            default:
                break;
            }
        }
        
        func registerWidge(widge: Widge) {
            
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
}

extension UIColor {
    func toString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        self.getRed(&r, green: &g, blue: &r, alpha: nil)
        return "\(r),\(g),\(b)"
    }
    
    convenience init(_ string: String) {
        let stringParts = string.componentsSeparatedByString(",") as [String]
        let floatParts = stringParts.map { CGFloat(($0 as NSString).floatValue) }
        assert(floatParts.count == 3)
        self.init(red:floatParts[0], green: floatParts[1], blue: floatParts[2], alpha: 1.0)
    }
}
