//
//  FGOutput.m
//  factory
//
//  Created by admin on 11/11/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGOutput.h"

@interface FGOutput ()

@property (nonatomic) SKLabelNode *label;
@property (nonatomic) int count;

@end

@implementation FGOutput

- (id)initWithOriginZone:(FGZone)zone
{
    if (self = [super initWithOriginZone:zone])
    {
        // draw
        [self addChild:[FGUtil zoneBoxWithBorder:[UIColor grayColor] innerColor:[UIColor blueColor]]];
        
        SKLabelNode *label = [SKLabelNode node];
        label.position = centerOf(FGZoneMake(0, 0));
        [self addChild:label];
        
        self.label = label;
        self.count = 0;
        
        // describe I/O
        [self addSimpleInputNamed:@"input"];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)_dt
{
    for (FGWidge *widge in [self.connectors[@"input"] dequeueWidges]) {
        [widge removeFromParent];
        self.count++;
    }
    self.label.text = [NSString stringWithFormat:@"%d", self.count];
}

@end
