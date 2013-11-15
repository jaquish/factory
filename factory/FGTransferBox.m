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
        [self addSimpleInputNamed:@"input"];
        [self addSimpleOutputNamed:@"output"];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)_dt
{
    ;
}

@end
