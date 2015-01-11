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
    case Combination = "Combination"
}

class Action : LevelFileObject {
    let actionID: String
    let actionType: ActionType
    let inputTypes: [WidgeType]
    var successTypes: [WidgeType]
    var failureTypes: [WidgeType]
    
    class func actionWith(actionType: ActionType, actionID: String, inputTypeIDs: [WidgeType], successTypeIDs: [WidgeType], failureTypeIDs: [WidgeType]) -> Action! {
        
        switch actionType {
        case .Transformation: return TransformAction(actionID: actionID, actionType: actionType, inputTypeIDs: inputTypeIDs, successTypeIDs: successTypeIDs, failureTypeIDs: failureTypeIDs)
        case .Combination : return CombinationAction(actionID: actionID, actionType: actionType, inputTypeIDs: inputTypeIDs, successTypeIDs: successTypeIDs, failureTypeIDs: failureTypeIDs)
        }
    }
    
    init(actionID: String, actionType: ActionType, inputTypeIDs: [WidgeType], successTypeIDs: [WidgeType], failureTypeIDs: [WidgeType]) {
        self.actionID = actionID
        self.actionType = actionType
        self.inputTypes = inputTypeIDs
        self.successTypes = successTypeIDs
        self.failureTypes = failureTypeIDs
    }
    
    class func numberOfInitializerParameters() -> Int {
        return 5
    }
}

class TransformAction : Action {
    
    func resultType(#input: WidgeType) -> WidgeType {
        if contains(inputTypes, "*") || inputTypes == [input] {
            return successTypes[0]
        } else {
            return failureTypes[0]
        }
    }
    
    func successType() -> WidgeType {
        return successTypes[0]
    }
}

class CombinationAction : Action {
    
    func resultType(#beltInput: WidgeType, containedInput: WidgeType) -> WidgeType {
        if beltInput == inputTypes[0] && containedInput == inputTypes[1] {
            return successTypes[0]
        } else {
            return failureTypes[0]
        }
    }
    
    func containedType() -> WidgeType {
        return inputTypes[1]
    }
    
    func successType() -> WidgeType {
        return successTypes[0]
    }
}