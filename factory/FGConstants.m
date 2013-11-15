//
//  FGConstants.m
//  factory
//
//  Created by admin on 11/3/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGConstants.h"

@implementation FGConstants

@end

const float WorldHeight =  768;
const float WorldWidth  = 1024;

const float ZoneSize  = 64.0;   // default 64
const float WidgeSize = 40.0;   // default 40

const float ZonesWide = WorldWidth / ZoneSize;
const float ZonesHigh = WorldHeight / ZoneSize;

const float SpriteLayerBackground      = -1;
const float SpriteLayerBehindWidges    =  0;
const float SpriteLayerWidges          =  1;
const float SpriteLayerInFrontOfWidges =  2;

BOOL DEBUG_SHOW_GRID = YES;

const float LabelFontSize = 24;