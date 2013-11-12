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

@end

@implementation FGGravity

- (id)init
{
    if (self = [super init]) {
        self.falling = [NSMutableArray array];
    }
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    [self.falling addObjectsFromArray:self.input.widges];
    
    for (FGWidge *widge in self.falling) {
        CGPoint position = widge.position;
        position.y -= kGravityPointsPerSecond * _dt;
        widge.position = position;
        
        if (widge.position.y < self.output.position.y) {
            CGPoint position = widge.position;
            position.y = self.output.position.y;
            widge.position = position;
            [self.falling removeObject:widge];
            [self.output insert:widge];
        }
    }
}

@end
