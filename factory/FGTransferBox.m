//
//  FGTransferBox.m
//  factory
//
//  Created by Zach Jaquish on 11/14/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGTransferBox.h"

@implementation FGTransferBox

- (id)initWithOriginZone:(FGZone)zone
{
    if (self = [super initWithOriginZone:zone]) {
        // draw
        [self addChild:[FGUtil zoneBoxWithBorder:[UIColor darkGrayColor] innerColor:[UIColor grayColor]]];
        
        // describe IO
        FGConnectionPoint *input  = [FGConnectionPoint pointWithPosition:centerOf(self.originZone) name:@"input"];
        input.priority = kConnectionPointPriorityHigh;
        [self addInput:input];
        
        FGConnectionPoint *output = [FGConnectionPoint pointWithPosition:centerOf(self.originZone) name:@"output"];
        output.priority = kConnectionPointPriorityHigh;
        [self addOutput:output];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)_dt
{
    ;
}

@end
