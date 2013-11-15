//
//  FGTransformer.m
//  factory
//
//  Created by Zach Jaquish on 11/13/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGTransformer.h"

@implementation FGTransformer

- (id)initWithOriginZone:(FGZone)zone
{
    if (self = [super initWithOriginZone:zone]) {
        
        // draw
        [self addChild:[FGUtil zoneBoxWithBorder:[UIColor yellowColor] innerColor:[UIColor colorWithRed:0.2 green:0.8 blue:0.8 alpha:1.0]]];
        
        // describe I/O
        [self addSimpleInputNamed:@"input"];
        [self addSimpleOutputNamed:@"output"];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)_dt
{
    NSArray* widges = [self.connectors[@"input"] dequeueWidges];
    
    for (FGWidge *widge in widges) {
        [widge removeFromParent];
        FGWidge* widge2 = [FGWidge yellowWidge];
        widge2.position = widge.position;
        [self.scene addChild:widge2];
        [self.connectors[@"output"] insert:widge2];
    }
}

@end
