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

- (id)initWithOriginZone:(FGZone)fromZone endZone:(FGZone)toZone
{
    if (self = [super initWithOriginZone:fromZone])
    {
        // ivars
        self.endZone = toZone;
        self.moving = [NSMutableArray array];
        
        // draw
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(ZoneSize * (toZone.x - fromZone.x + 1), kHorizontalBeltHeight)];
        spriteNode.anchorPoint = CGPointZero;
        [self addChild:spriteNode];
        
        // describe I/O
        for (int i = self.originZone.x; i <= self.endZone.x; i++) {
            [self addInput:  [FGConnectionPoint pointWithPosition:centerOf(FGZoneMake(i, self.originZone.y)) name:[NSString stringWithFormat:@"input-%d", i]]];
            [self addOutput: [FGConnectionPoint pointWithPosition:centerOf(FGZoneMake(i, self.originZone.y)) name:[NSString stringWithFormat:@"output-%d", i]]];
        }
        
        [self addOutput:[FGConnectionPoint pointWithPosition:centerOf(zoneInDirectionFromZone(E, self.endZone)) name:@"output"]];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)_dt
{
    // iterate over subtiles
    for (int i = self.originZone.x; i <= self.endZone.x; i++) {
        <#statements#>
    }
    
    // widges already in motion
    NSMutableArray *toDelete = [NSMutableArray array];
    for (FGWidge* widge in self.moving) {
        
        float fallingPointX = compassPointOfZone(center, zoneInDirectionFromZone(E, self.endZone)).x;
        float deltaX = kBeltSpeedPointsPerSecond * _dt;
        
        if (widge.position.x + deltaX > fallingPointX) {
            [widge changeXTo:fallingPointX];
            [self.connectors[@"output"] insert:widge];
            [toDelete addObject:widge];
        } else {
            [widge changeXBy:kBeltSpeedPointsPerSecond * _dt];
        }
    }
    [self.moving removeObjectsInArray:toDelete];
    
    // new widges
    for (FGConnector *connector in [self inputs]) {
        NSArray *widges = [connector dequeueWidges];
        for (FGWidge *widge in widges) {
            [widge changeXBy:kBeltSpeedPointsPerSecond * _dt];
        }
        [self.moving addObjectsFromArray:widges];
    }
}

@end
