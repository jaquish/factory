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

    class func widgeWith(color: UIColor) -> Widge {
        let widge = Widge(color: color, size: CGSizeMake(WidgeSize, WidgeSize))
        widge.zPosition = SpriteLayerWidges
        return widge
    }
    
    class func redWidge() -> Widge {
        return Widge.widgeWith(UIColor.redColor())
    }
    
    class func orangeWidge() -> Widge {
        return Widge.widgeWith(UIColor.orangeColor())
    }
    
    class func yellowWidge() -> Widge {
        return Widge.widgeWith(UIColor.yellowColor())
    }
    
    class func greenWidge() -> Widge {
        return Widge.widgeWith(UIColor.greenColor())
    }
    
    class func blueWidge() -> Widge {
        return Widge.widgeWith(UIColor.blueColor())
    }
    
    class func purpleWidge() -> Widge {
        return Widge.widgeWith(UIColor.purpleColor())
    }
}
