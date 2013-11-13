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
    if (self = [super initWithRootZone:fromZone])
    {
        // ivars
        self.endZone = toZone;
        self.moving = [NSMutableArray array];
        
        // draw
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(ZoneSize * (toZone.x - fromZone.x + 1), kHorizontalBeltHeight)];
        spriteNode.anchorPoint = CGPointZero;
        [self addChild:spriteNode];
        
        // describe I/O
        [self addInput: [FGConnectionPoint pointWithPosition:compassPointOfZone(center, self.rootZone) name:@"input"]];
        [self addOutput:[FGConnectionPoint pointWithPosition:compassPointOfZone(center, zoneInDirectionFromZone(E, self.endZone)) name:@"output"]];
    }
    
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    [self.moving addObjectsFromArray:[self.connectors[@"input"] widges]];
    
    NSMutableArray *toDelete = [NSMutableArray array];
    for (FGWidge* widge in self.moving) {
        [widge changeXBy:kBeltSpeedPointsPerSecond * _dt];
        
        int fallingPointX = compassPointOfZone(center, zoneInDirectionFromZone(E, self.endZone)).x;
        if (widge.position.x > fallingPointX) {
            [widge changeXTo:fallingPointX];
            [self.connectors[@"output"] insert:widge];
            [toDelete addObject:widge];
        }
    }
    [self.moving removeObjectsInArray:toDelete];
}

@end
