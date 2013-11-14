//
//  FGInput.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGInput.h"

@interface FGInput ()

@property (nonatomic) NSMutableArray *generated;

@end

@implementation FGInput

- (id)initWithOriginZone:(FGZone)zone
{
    if (self = [super initWithOriginZone:zone])
    {
        // ivars
        self.generated = [NSMutableArray array];
        
        // draw
        [self addChild:[FGUtil zoneBoxWithBorder:[UIColor grayColor] innerColor:[UIColor greenColor]]];
        
        // describe I/O
        [self addOutput:[FGConnectionPoint pointWithPosition:centerOf(self.originZone) name:@"next"]];
    }
    
    return self;
}

- (void)generateWidge
{
    FGWidge *widge = [FGWidge redWidge];
    CGPoint generationPoint = compassPointOfZone(center, self.originZone);
    widge.position = generationPoint;
    [self.generated addObject:widge];
    [self.scene addChild:widge];
}

- (void)update:(CFTimeInterval)_dt
{
    for (FGWidge* widge in self.generated) {
        [self.connectors[@"next"] insert:widge];
    }
    [self.generated removeAllObjects];
}

@end
