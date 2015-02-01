//
//  WidgeGraphManager.swift
//  factory
//
//  Created by Zach Jaquish on 1/30/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit

typealias WidgeTypeID = String

class WidgeType : Hashable {
    let ID: WidgeTypeID
    let color: UIColor!
    let spriteName: String!
    let garbage: WidgeType!
    
    class func basicWidgeTypes() -> [WidgeType] {
        
        let black = WidgeType(id: "black", color: UIColor.blackColor(), garbage: nil)
        return [
            black,
            WidgeType(id:"red",    color:UIColor.redColor(), garbage: black),
            WidgeType(id:"orange", color:UIColor.orangeColor(), garbage: black),
            WidgeType(id:"yellow", color:UIColor.yellowColor(), garbage: black),
            WidgeType(id:"green",  color:UIColor.greenColor(), garbage: black),
            WidgeType(id:"blue",   color:UIColor.blueColor(), garbage: black),
            WidgeType(id:"purple", color:UIColor.purpleColor(), garbage: black)
        ]
    }
    
    init(id: WidgeTypeID, color: UIColor, var garbage: WidgeType! = nil) {
       
        self.ID = id
        self.color = color
        
        if garbage == nil {
            garbage = self // If no garbage type provided, loop onto self
        }
        self.garbage = garbage
    }
    
    init(id: WidgeTypeID, spriteName: String, var garbage: WidgeType! = nil) {
        
        self.ID = id
        self.spriteName = spriteName
        
        if garbage == nil {
            garbage = self
        }
    }
    
    func visual() -> AnyObject {
        return color ?? spriteName!
    }
    
    var hashValue: Int {
        return self.ID.hashValue
    }
}

func ==(lhs: WidgeType, rhs: WidgeType) -> Bool {
    return lhs.ID == rhs.ID
}

class WidgeGraphManager {
    var widgeTypes:[WidgeType] = []
    var actions:[Action]  = []
    
    func action(id: ActionID) -> Action {
        return actions.filter({ $0.ID == id }).first!
    }
    
    func widgeType(id: WidgeTypeID) -> WidgeType {
        return widgeTypes.filter({ $0.ID == id }).first!
    }
    
    func register(widgeType: WidgeType) {
        if (widgeTypes.filter { $0.ID == widgeType.ID }).count > 0 {
            println("Warning: widgeType already registered with that ID")
        } else {
            widgeTypes.append(widgeType)
        }
    }
    
    func register(action: Action) {
        if (actions.filter { $0.ID == action.ID }).count > 0 {
            println("Warning: action already registered with that ID")
        } else {
            actions.append(action)
        }
    }
    
    
}
