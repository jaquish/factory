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
    for (FGWidge *widge in self.falling) {
        CGPoint position = widge.position;
        position.y -= kGravityPointsPerSecond * _dt;
        widge.position = position;
    }
}

- (void)add:(FGWidge *)widge
{
    [self.falling addObject:widge];
}

@end
