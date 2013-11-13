//
//  FGMachine.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGMachine.h"
#import "FGConnector.h"

@implementation FGMachine

- (id)init
{
    if (self = [super init])
    {
        self.connectors = [NSMutableArray array];
        self.anchorPoint = CGPointZero; // position machine from lower left
    }
    
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    ;   // Do something!
}

- (void)propogate
{
    ;   // Do something!
}

- (void)setRootZone:(FGZone)rootZone
{
    _rootZone = rootZone;
    self.position = compassPointOfZone(SW, rootZone);
}

- (void)organizeConnectors
{
    for (FGConnectionPoint *cp in self.connectionPoints) {
        if (cp.connector) {
            [self.connectors addObject:cp.connector];
        }
    }
}

@end
