//
//  StatusBar.swift
//  factory
//
//  Created by Zach Jaquish on 1/28/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit
import SpriteKit

class StatusBar: UIView {

    var status: UILabel!
    override init() {
        
        super.init(frame: CGRectZero)
       
        self.frame = CGRect(x: ZoneWidth*3, y: 0, width: 600, height: ZoneHeight)
        self.backgroundColor = UIColor.lightGrayColor()
        
        let toggleDebug = UIButton(frame: CGRect(x: 40, y: 10, width: 80, height: 40))
        toggleDebug.setTitle("Debug", forState: .Normal)
        toggleDebug.showsTouchWhenHighlighted = true
        
        toggleDebug.addTarget(self, action: "toggleDebug:", forControlEvents: .TouchUpInside)
        addSubview(toggleDebug)
        
        status = UILabel(frame: CGRect(x: 300, y: 10, width: 200, height: 40))
        status.textColor = UIColor.whiteColor()
        addSubview(status)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWith(outputCount: Int, endGameCount: Int) {
        status.text = "Outputs: \(outputCount) / \(endGameCount)"
    }
    
    func toggleDebug(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(DebugViewNotification, object: nil)
    }
}
