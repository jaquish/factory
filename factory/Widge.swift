//
//  Widge.swift
//  factory
//
//  Created by Zach Jaquish on 11/3/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

var AllWidges = [Widge]()

var widgeTypes = [String : String]()

class Widge: SKSpriteNode, LevelFileObject {
    
    var owner: AnyObject! // Machine or Connector
    var state: WidgeState!
    
    var widgeTypeID: String!

    class func widgeBy(typeID:String) -> Widge? {
        if let value = widgeTypes[typeID] {
            if value.hasPrefix("$") {
                let colorString = value.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "$"))
                return widgeWith(typeID, color: UIColor(colorString))
            }
        }
        return nil
    }
    
    class func widgeWith(typeID:String, color: UIColor) -> Widge {
        let widge = Widge(color: color, size: CGSizeMake(WidgeSize, WidgeSize))
        widge.widgeTypeID = typeID
        widge.zPosition = SpriteLayerWidges
        AllWidges.append(widge)
        return widge
    }
    
    class func garbage() -> Widge {
        return widgeWith("garbage", color: UIColor.blackColor())
    }
    
    class func numberOfInitializerParameters() -> Int {
        return 2
    }
    
    class func register(typeName:String, spriteName:String) {
        widgeTypes[typeName] = spriteName
    }
    
    class func registerBasicWidges() {
        register("red",     spriteName: "$\(UIColor.redColor().toString())")
        register("orange",  spriteName: "$\(UIColor.orangeColor().toString())")
        register("yellow",  spriteName: "$\(UIColor.yellowColor().toString())")
        register("green",   spriteName: "$\(UIColor.greenColor().toString())")
        register("blue",    spriteName: "$\(UIColor.blueColor().toString())")
        register("purple",  spriteName: "$\(UIColor.purpleColor().toString())")
        register("black",   spriteName: "$\(UIColor.blackColor().toString())")
    }
}
