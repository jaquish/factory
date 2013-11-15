//
//  FGTransformer.m
//  factory
//
//  Created by Zach Jaquish on 11/13/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGTransformer.h"

@interface FGTransformer ()

@property (nonatomic) UIColor *finalColor;

@end

@implementation FGTransformer

- (id)initWithOriginZone:(FGZone)zone color:(UIColor*)color
{
    if (self = [super initWithOriginZone:zone]) {
        // ivars
        self.finalColor = color;
        
        // draw
        [self addChild:[FGUtil zoneBoxWithBorder:self.finalColor innerColor:[UIColor darkGrayColor]]];
        
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
        FGWidge* widge2 = [FGWidge widgeWithColor:self.finalColor];
        widge2.position = widge.position;
        [self.scene addChild:widge2];
        [self.connectors[@"output"] insert:widge2];
    }
}

@end
