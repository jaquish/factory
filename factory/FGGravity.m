//
//  FGGravity.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGGravity.h"

const float kGravityPointsPerSecond = 300.0;

@interface FGGravity ()

@property NSMutableArray *falling;
@property (nonatomic) FGZone endZone;

@end

@implementation FGGravity

- (id)initWithRootZone:(FGZone)zone endZone:(FGZone)end
{
    if (self = [super initWithRootZone:zone]) {
        // ivars
        self.endZone = end;
        self.falling = [NSMutableArray array];
        
        // describe I/O
        FGConnectionPoint *top = [[FGConnectionPoint alloc] init];
        top.position = compassPointOfZone(center, self.rootZone);
        top.name = @"top";
        top.machine = self;
        [self.connectionPointInputs addObject:top];
        
        FGConnectionPoint *bottom = [[FGConnectionPoint alloc] init];
        bottom.position = compassPointOfZone(center, self.endZone);
        bottom.name = @"bottom";
        bottom.machine = self;
        [self.connectionPointOutputs addObject:bottom];
    }
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    [self.falling addObjectsFromArray:[self.connectors[@"top"] widges]];
    
    NSLog(@"Falling %d objects", [self.falling count]);
    NSMutableArray *toDelete = [NSMutableArray array];
    for (FGWidge *widge in self.falling) {
        [widge changeYBy:-kGravityPointsPerSecond * _dt];
        
        if (self.connectors[@"bottom"]) {
            float bottomY = [self.connectors[@"bottom"] position].y;
            if (widge.position.y < bottomY) {
                [widge changeYTo:bottomY];
                [toDelete addObject:widge];
                [self.connectors[@"bottom"] insert:widge];
            }
        }
    }
    [self.falling removeObjectsInArray:toDelete];
}

@end
