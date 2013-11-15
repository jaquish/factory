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
        [self addChild:[FGUtil zoneBoxWithBorder:[UIColor grayColor] innerColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.8 alpha:1.0]]];
        
        float inset = 8;
        SKLabelNode *label = [SKLabelNode node];
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        label.position = CGPointMake(compassPointOfZone(N, FGZoneZero).x, compassPointOfZone(N, FGZoneZero).y - inset);
        label.fontSize = LabelFontSize;
        [self addChild:label];
        
        SKLabelNode *label2 = [SKLabelNode node];
        label2.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        label2.position = CGPointMake(compassPointOfZone(S, FGZoneZero).x, compassPointOfZone(S, FGZoneZero).y + inset);
        label2.fontSize = LabelFontSize;
        label2.text = @"OUT";
        [self addChild:label2];
        
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
