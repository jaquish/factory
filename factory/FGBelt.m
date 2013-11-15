//
//  FGBelt.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGBelt.h"

const static float kBeltSpeedPointsPerSecond = 100.0;

const static float kVerticalBeltWidth = 12.0;

@interface FGBelt ()

@property NSMutableArray *moving;

@end

@implementation FGBelt

- (id)initWithOriginZone:(FGZone)fromZone endZone:(FGZone)toZone
{
    if (self = [super initWithOriginZone:fromZone])
    {
        self.zPosition = SpriteLayerBehindWidges;
        
        // ivars
        self.endZone = toZone;
        self.moving = [NSMutableArray array];
        
        // draw
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(ZoneSize * (toZone.x - fromZone.x + 1), kVerticalBeltWidth)];
        spriteNode.anchorPoint = CGPointZero;
        [self addChild:spriteNode];
        
        // describe I/O
        for (int i = self.originZone.x; i <= self.endZone.x; i++) {
            [self addInput:  [FGConnectionPoint pointWithPosition:centerOf(FGZoneMake(i, self.originZone.y)) name:[NSString stringWithFormat:@"input-%d", i]]];
            [self addOutput: [FGConnectionPoint pointWithPosition:centerOf(FGZoneMake(i, self.originZone.y)) name:[NSString stringWithFormat:@"output-%d", i]]];
        }
        
        [self addOutput:[FGConnectionPoint pointWithPosition:centerOf(zoneInDirectionFromZone(E, self.endZone)) name:@"over-right-edge"]];
    }
    
    return self;
}

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

@end
