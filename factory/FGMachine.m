//
//  FGMachine.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGMachine.h"
#import "FGConnector.h"
#import "FGConnectionPoint.h"

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
    NSLog(@"Connectors for %@", self.name);
    for (FGConnectionPoint *cp in [self.connectionPointInputs arrayByAddingObjectsFromArray:self.connectionPointOutputs]) {
        if (cp.connector) {
            self.connectors[cp.name] = cp.connector;    // key on named connection point
            NSLog(@"-- %@", cp.name);
        }
    }
}

- (void)addInput:(FGConnectionPoint*)cp
{
    cp.machine = self;
    NSAssert([cp.name length], @"Connection point should have a name.");
    [self.connectionPointInputs addObject:cp];
}

- (void)addOutput:(FGConnectionPoint*)cp
{
    cp.machine = self;
    NSAssert([cp.name length], @"Connection point should have a name.");
    [self.connectionPointOutputs addObject:cp];
}

- (FGConnector*)connectorWithName:(NSString*)name
{
    return self.connectors[name];
}

- (NSArray*)inputs
{
    return [[self.connectors allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"destination == self"]];
}

- (NSArray*)outputs
{
    return [[self.connectors allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"source == self"]];
}

@end
