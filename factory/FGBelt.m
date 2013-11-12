//
//  FGBelt.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGBelt.h"

const float kBeltSpeedPointsPerSecond = 100.0;

float const kHorizontalBeltHeight = 12.0;

@interface FGBelt ()

@property NSMutableArray *moving;

@end

@implementation FGBelt

- (id)initFromRootZone:(FGZone)fromZone toZone:(FGZone)toZone
{
    if (self = [super init])
    {
        self.rootZone = fromZone;
        self.endZone = toZone;
        
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(ZoneSize * (toZone.x - fromZone.x + 1), kHorizontalBeltHeight)];
        spriteNode.anchorPoint = CGPointZero;
        [self addChild:spriteNode];
        
        self.moving = [NSMutableArray array];
    }
    
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    [self.moving addObjectsFromArray:self.input.widges];
    
    for (FGWidge* widge in self.moving) {
        [widge changeXBy:kBeltSpeedPointsPerSecond * _dt];
        
        int fallingPointX = compassPointOfZone(center, zoneInDirectionFromZone(E, self.endZone)).x;
        if (widge.position.x > fallingPointX) {
            [widge changeXTo:fallingPointX];
            [self.output insert:widge];
            [self.moving removeObject:widge];
        }
    }
}

@end
