//
//  StatusBar.swift
//  factory
//
//  Created by Zach Jaquish on 1/28/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class StatusBar: SKSpriteNode {

    override init() {
        super.init(texture: nil, color: nil, size: CGSizeZero)
        let info = SKLabelNode()
        addChild(info)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
