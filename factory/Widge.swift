//
//  Widge.swift
//  factory
//
//  Created by Zach Jaquish on 11/3/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private var nextWidgeID = 1

class Widge: SKSpriteNode, LevelFileObject {
    
    let widgeID: Int
    let widgeType: WidgeType
    
    var owner: AnyObject! // Machine or Connector
    var state: WidgeState!
    
    /**
    Create a widge with the given type.
    
    :param: widgeType
    
    :returns: A widge sprite that just needs to be added to the level.
    */
    init(widgeType: WidgeType) {
        widgeID = nextWidgeID
        nextWidgeID++
        
        self.widgeType = widgeType
        
        // choose image or basic color
        let visual: AnyObject = widgeType.visual()
        switch visual {
        case is UIColor:
            super.init(texture: nil, color: visual as UIColor, size: WidgeSize)
        case is UIImage:
            super.init(texture: SKTexture(image: visual as UIImage), color: nil, size: WidgeSize)
        default:
            fatalError("Unable to process widgeType")
        }
        
        zPosition = SpriteLayerWidges
        self.userData = [:]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func numberOfInitializerParameters() -> Int {
        return 2
    }
}
