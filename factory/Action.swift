//
//  Action.swift
//  factory
//
//  Created by Zach Jaquish on 1/30/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import Foundation

typealias ActionID = String

class Action {
    let ID: ActionID
    
    init(ID: ActionID) {
        self.ID = ID
    }
}