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
    if (self.connector || otherPoint.connector) {
        return; // one end-point was already connected
    }
    
    if (self.position.x == otherPoint.position.x &&
        self.position.y == otherPoint.position.y    ) {
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
