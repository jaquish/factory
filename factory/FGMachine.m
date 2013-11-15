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

- (id)initWithOriginZone:(FGZone)zone
{
    if (self = [super init])
    {
        self.connectionPointInputs = [NSMutableArray array];
        self.connectionPointOutputs = [NSMutableArray array];
        self.connectors = [NSMutableDictionary dictionary];
        self.anchorPoint = CGPointZero; // position machine from lower left
        
        self.originZone = zone;
    }
    
    return self;
}

- (void)update:(CFTimeInterval)_dt
{
    ;   // Do something!
}

- (void)propogate
{
    ;   // Do something!
}

- (void)setOriginZone:(FGZone)originZone
{
    _originZone = originZone;
    self.position = compassPointOfZone(SW, originZone);
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

- (void)addSimpleInputNamed:(NSString*)name
{
    FGConnectionPoint *cp = [[FGConnectionPoint alloc] init];
    cp.position = centerOf(self.originZone);
    cp.name = name;
    [self addInput:cp];
}

- (void)addSimpleOutputNamed:(NSString*)name
{
    FGConnectionPoint *cp = [[FGConnectionPoint alloc] init];
    cp.position = centerOf(self.originZone);
    cp.name = name;
    [self addOutput:cp];
}

- (FGConnector*)connectorWithName:(NSString*)name
{
    return self.connectors[name];
}

- (NSArray*)inputs
{
    NSMutableArray *inputs = [NSMutableArray array];
    for (FGConnector *connector in [self.connectors allValues]) {
        if (connector.destination == self) {
            [inputs addObject:connector];
        }
    }
    return inputs;
//    return [[self.connectors allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"destination == self"]];
}

- (NSArray*)outputs
{
    NSMutableArray *outputs = [NSMutableArray array];
    for (FGConnector *connector in [self.connectors allValues]) {
        if (connector.source == self) {
            [outputs addObject:connector];
        }
    }
    return outputs;
//    return [[self.connectors allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"source == self"]];
}

@end
