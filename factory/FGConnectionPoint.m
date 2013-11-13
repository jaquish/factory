//
//  FGConnectionPoint.m
//  factory
//
//  Created by admin on 11/12/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGConnectionPoint.h"

@implementation FGConnectionPoint

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
