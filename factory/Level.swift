//
//  Level.swift
//  factory
//
//  Created by Zach Jaquish on 11/12/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

var CurrentLevel: Level!

class Level: NSObject {
   
    var preamble = String()
    
    var inputMachine: Input!
    var inputWidgeTypes  = [String]()
    var outputWidgeTypes = [String]()
    
    var actions = [String : Action]()

    var machines: [Machine] = Array()
    
    var metadata = [String : AnyObject]()
    
    var outputs = [String : Int]()
    var endgame_output_count: Int = 0
    
    func summary() -> String {
        var summary = ""
        for (key, value) in metadata {
            summary += "\(key) : \(value)\n"
        }
        summary += "\n\n" + preamble
        return summary
    }

    func createWidge(widgeTypeID: String) -> Widge {
        var spriteName = widgeTypes[widgeTypeID]!
        if spriteName.hasPrefix("$") {
            spriteName = spriteName.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "$"))
            return Widge.widgeWith(widgeTypeID, color: UIColor(spriteName))
        } else {
            println("Warning! not ready to process")
            return Widge.garbage()
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
