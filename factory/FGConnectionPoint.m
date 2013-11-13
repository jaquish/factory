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
    } else {
        // create new connector and set
        FGConnector *connector = [[FGConnector alloc] init];
        connector.position = self.position;
        connector.source = self.machine;
        connector.destination = otherPoint.machine;
        self.connector = connector;
    }
}

@end
