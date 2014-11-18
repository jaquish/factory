//
//  Widge.swift
//  factory
//
//  Created by Zach Jaquish on 11/3/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class Widge: SKSpriteNode {
    
    var widgeTypeID: String!

    class func widgeWith(typeID:String, color: UIColor) -> Widge {
        let widge = Widge(color: color, size: CGSizeMake(WidgeSize, WidgeSize))
        widge.widgeTypeID = typeID
        widge.zPosition = SpriteLayerWidges
        return widge
    }
    
    class func redWidge() -> Widge {
        return Widge.widgeWith("red", color:UIColor.redColor())
    }
    
    class func orangeWidge() -> Widge {
        return Widge.widgeWith("orange", color:UIColor.orangeColor())
    }
    
    class func yellowWidge() -> Widge {
        return Widge.widgeWith("yellow", color:UIColor.yellowColor())
    }
    
    class func greenWidge() -> Widge {
        return Widge.widgeWith("green", color:UIColor.greenColor())
    }
    
    class func blueWidge() -> Widge {
        return Widge.widgeWith("blue", color:UIColor.blueColor())
    }
    
    class func purpleWidge() -> Widge {
        return Widge.widgeWith("purple", color:UIColor.purpleColor())
    }
}
