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
float const kVerticalBeltHeight = 64.0;

@interface FGBelt ()

@property NSMutableArray *moving;

@end

@implementation FGBelt

- (id)init
{
    if (self = [super init])
    {
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(64, kHorizontalBeltHeight)];
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
        
        if (widge.position.x > compassPointOfZone(center, self.endZone).x) {
            [widge changeXTo:compassPointOfZone(center, self.endZone).x];
            [self.output insert:widge];
            [self.moving removeObject:widge];
        }
    }
}

@end
