//
//  Action.swift
//  factory
//
//  Created by Zach Jaquish on 11/17/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

enum ActionType : String {
    case Transformation = "Transformation"
}

struct Action {
    let actionID: String
    let actionType: ActionType
    let inputTypeIDs: [String]
    var successTypeIDs: [String]
    var failureTypeIDs: [String]
    
    func performAction(inputs:[String]) -> [String] {
        if inputs == inputTypeIDs || contains(inputTypeIDs, "*") {
            return successTypeIDs
        } else {
            return failureTypeIDs
        }
    }
}