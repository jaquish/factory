//
//  Helpers.swift
//  factory
//
//  Created by Zach Jaquish on 2/2/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import Foundation

func charForDirection(d:Direction) -> String {
    switch d {
    case .N:  return "⬆️"
    case .NE: return "↗️"
    case .E:  return "➡️"
    case .SE: return "↘️"
    case .S:  return "⬇️"
    case .SW: return "↙️"
    case .W:  return "⬅️"
    case .NW: return "↖️"
    case .center: fatalError("Invalid direction ")
    }
}