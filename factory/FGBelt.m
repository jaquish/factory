//
//  FGBelt.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGBelt.h"

const float kBeltSpeedPointsPerSecond;

@interface FGBelt ()

@property NSMutableArray *moving;

@end

@implementation FGBelt

- (id)init
{
    if (self = [super init])
    {
        self.moving = [NSMutableArray array];
    }
    
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    for (FGWidge* widge in self.moving) {
        CGPoint position = widge.position;
        position.x += kBeltSpeedPointsPerSecond;
        widge.position = position;
    }
}

@end
