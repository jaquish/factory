//
//  FGConnectionPoint.m
//  factory
//
//  Created by admin on 11/12/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGConnectionPoint.h"
#import "FGConnector.h"
#import "FGMachine.h"

const unsigned int kConnectionPointPriorityHigh = 1;

@implementation FGConnectionPoint

+ (instancetype)pointWithPosition:(CGPoint)position name:(NSString*)name
{
    return [[FGConnectionPoint alloc] initWithPosition:position name:name];
}

- (instancetype)initWithPosition:(CGPoint)position name:(NSString*)name
{
    if (self = [super init])
    {
        self.position = position;
        self.name = name;
    }
    
    return self;
}


- (void)tryToConnectToPoint:(FGConnectionPoint *)otherPoint
{
    /* Basic connection point rules */
    
    // don't connect a connection point that has already been connected
    if (self.connector || otherPoint.connector) {
        return;
    }
    
     // don't connect a machine to itself
    if (self.machine == otherPoint.machine) {
        return;
    }
    
    // don't connect if connection points are not in the same position
    if (!CGPointEqualToPoint(self.position, otherPoint.position)) {
        return;
    }
    
    /* Ask the machines involved for advanced connection point rules */
    if ([self.machine       allowConnectionWithMachine:otherPoint.machine] &&
        [otherPoint.machine allowConnectionWithMachine:self.machine]        ) {
        
        // create new connector and set
        FGConnector *connector = [[FGConnector alloc] init];
        connector.position = self.position;
        connector.source = self.machine;
        connector.destination = otherPoint.machine;
        
        // point both connection points to single connector
        self.connector = connector;
        otherPoint.connector = connector;
        
        NSLog(@"Connected %@ \"%@\" to %@ \"%@\"", self.machine.name, self.name, otherPoint.machine.name, otherPoint.name);
    }
}

@end
