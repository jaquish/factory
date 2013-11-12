//
//  FGBelt.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGBelt.h"

const float kBeltSpeedPointsPerSecond = 50.0;

float const kHorizontalBeltHeight = 12.0;
float const kVerticalBeltHeight = 64.0;

@interface FGBelt ()

@property NSMutableArray *moving;

@end

@implementation FGBelt

- (id)init
{
    if (self = [super initWithColor:[UIColor grayColor] size:CGSizeMake(64, kHorizontalBeltHeight)])
    {
        self.moving = [NSMutableArray array];
    }
    
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    [self.moving addObjectsFromArray:self.input.widges];
    
    for (FGWidge* widge in self.moving) {
        CGPoint position = widge.position;
        position.x += kBeltSpeedPointsPerSecond * _dt;
        widge.position = position;
    }
}

@end
