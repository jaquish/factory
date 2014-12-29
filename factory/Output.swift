//
//  Output.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

private let OutputWidge: WidgeState = "OutputWidge"

class Output: Machine {
    
    let label: SKLabelNode
    var count: Int = 0 {
        didSet {
            label.text = "\(count)"
        }
    }
    
    init(_ originZone: Zone) {
        
        let title = SKLabelNode()
        title.position = ZoneZero.worldPoint(.center)
        title.position.y += 4
        title.fontSize = LabelFontSize
        title.text = "OUT"
        
        label = SKLabelNode()
        label.position = ZoneZero.worldPoint(.center)
        label.position.y -= 20
        label.fontSize = LabelFontSize
        
        super.init(originZone: originZone)
        
        addChild(Util .zoneBoxWithBorder(UIColor.grayColor(), innerColor:UIColor(red: 0.2, green: 0.2, blue: 0.8, alpha: 1.0)))
        addChild(title)
        addChild(label)
        addInput(originZone^(.center), name: "input", startingState: OutputWidge)
        
        self.color = UIColor.grayColor().colorWithAlphaComponent(0.2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_dt: CFTimeInterval) {
        connector("input").dequeueWidges()
        for widge in widgesInState(OutputWidge) {
            count += 1
            CurrentLevel.addOutput(widge.widgeTypeID)
            deleteWidge(widge)
        }
    }
    
    override func description() -> String {
        return "Output at \(originZone)"
    }
}
