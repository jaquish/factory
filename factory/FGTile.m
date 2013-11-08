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
    
    tile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tile.size];
    tile.physicsBody.dynamic = YES;
     /*
    tile.physicsBody.categoryBitMask = tileCategory;
    tile.physicsBody.contactTestBitMask = widgeCategory;
    tile.physicsBody.collisionBitMask = 0; // don't bounce off anything
    */
    return tile;
}

@end
