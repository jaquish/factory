//
//  Constants.swift
//  factory
//
//  Created by Zach Jaquish on 11/8/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

let WorldHeight: CGFloat = 768.0
let WorldWidth: CGFloat  = 1024;

let ZoneSize: CGFloat  = 64.0   // default 64
let WidgeSize: CGFloat = 40.0   // default 40

let ZonesWide: CGFloat = WorldWidth / ZoneSize;
let ZonesHigh: CGFloat = WorldHeight / ZoneSize;

let SpriteLayerBackground: CGFloat      = -1.0
let SpriteLayerBehindWidges: CGFloat    =  0.0
let SpriteLayerWidges: CGFloat          =  1.0
let SpriteLayerInFrontOfWidges: CGFloat =  2.0

let DEBUG_SHOW_GRID = true
let DEBUG_SHOW_NUMBERS = true

let LabelFontSize: CGFloat = 24