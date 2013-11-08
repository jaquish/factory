//
//  FGTile.m
//  factory
//
//  Created by admin on 11/2/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGTile.h"

float const kTileWidth = 64.0;

float const kTileHorizontalBeltHeight = 12.0;


@implementation FGTile

+ (instancetype)beltEast
{
    FGTile *tile = [self spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(64, kTileHorizontalBeltHeight)];
    return tile;
}

@end
