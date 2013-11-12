//
//  FGOutput.m
//  factory
//
//  Created by admin on 11/11/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGOutput.h"

@implementation FGOutput

- (id)init
{
    if (self = [super init])
    {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.1 green:0.7 blue:0.2 alpha:1.0] size:CGSizeMake(ZoneSize, ZoneSize)];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite];
    }
    
    return self;
}

@end
