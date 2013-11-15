//
//  FGVerticalBelt.m
//  factory
//
//  Created by Zach Jaquish on 11/14/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGVerticalBelt.h"

const static float kBeltSpeedPointsPerSecond = 100.0;

const static float kVerticalBeltWidth = 30.0;

@interface FGVerticalBelt ()

@property NSMutableArray *moving;

@end

@implementation FGVerticalBelt

- (id)initWithOriginZone:(FGZone)fromZone endZone:(FGZone)toZone
{
    if (self = [super initWithOriginZone:fromZone])
    {
        // ivars
        self.endZone = toZone;
        self.moving = [NSMutableArray array];
        
        // draw
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.0 green:0.4 blue:0.9 alpha:1.0] size:CGSizeMake(kVerticalBeltWidth, ZoneSize * (toZone.y - fromZone.y + 1))];
        spriteNode.anchorPoint = CGPointMake(0.5, 0);
        spriteNode.position = compassPointOfZone(S, FGZoneZero);
        [self addChild:spriteNode];
        
        // describe I/O
        [self addSimpleInputNamed:@"input"];
        [self addOutput:[FGConnectionPoint pointWithPosition:centerOf(self.endZone) name:@"output"]];
    }
    return self;
}
/*
- (void)update:(CFTimeInterval)_dt
{
    // TODO - save leftover deltaTime to update
    
    float deltaX = kBeltSpeedPointsPerSecond * _dt;
    
    // Fetch fresh widgets
    for (FGConnector* connector in self.inputs) {
        [self.moving addObjectsFromArray:[connector dequeueWidges]];
    }
    
    // Move widges, check for collision with output
    NSMutableArray *toDelete = [NSMutableArray array];
    for (FGWidge* widge in self.moving) {
        CGPoint oldPosition = widge.position;
        [widge changeXBy:deltaX];
        for (FGConnector *connector in [self outputs]) {
            // check if widge passed over connection point
            if (oldPosition.x < connector.position.x && widge.position.x >= connector.position.x) {
                [widge changeXTo:connector.position.x];
                [connector insert:widge];
                [toDelete addObject:widge];
            }
        }
    }
    [self.moving removeObjectsInArray:toDelete];
}
 */

@end
