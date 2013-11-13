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

- (id)initWithRootZone:(FGZone)zone
{
    if (self = [super init])
    {
        self.connectionPointInputs = [NSMutableArray array];
        self.connectionPointOutputs = [NSMutableArray array];
        self.connectors = [NSMutableDictionary dictionary];
        self.anchorPoint = CGPointZero; // position machine from lower left
        
        self.rootZone = zone;
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
    NSLog(@"Connectors for %@", self);
    for (FGConnectionPoint *cp in [self.connectionPointInputs arrayByAddingObjectsFromArray:self.connectionPointOutputs]) {
        if (cp.connector) {
            self.connectors[cp.name] = cp.connector;    // key on named connection point
            NSLog(@"-- %@", cp.name);
        }
    }
}

@end
