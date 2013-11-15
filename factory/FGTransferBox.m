//
//  FGTransferBox.m
//  factory
//
//  Created by Zach Jaquish on 11/14/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGTransferBox.h"

@implementation FGTransferBox

- (id)initWithOriginZone:(FGZone)zone
{
    if (self = [super initWithOriginZone:zone]) {
        
        self.zPosition = SpriteLayerInFrontOfWidges;  // transfer boxes are on top of other machines
        
        // draw
        [self addChild:[FGUtil zoneBoxWithBorder:[UIColor darkGrayColor] innerColor:[UIColor grayColor]]];
        
        // describe IO
        FGConnectionPoint *input  = [FGConnectionPoint pointWithPosition:centerOf(self.originZone) name:@"input"];
        input.priority = kConnectionPointPriorityHigh;
        [self addInput:input];
        
        FGConnectionPoint *output = [FGConnectionPoint pointWithPosition:centerOf(self.originZone) name:@"output"];
        output.priority = kConnectionPointPriorityHigh;
        [self addOutput:output];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)_dt
{
    for (FGWidge *widge in [[self connectorWithName:@"input"] dequeueWidges]) {
        [[self connectorWithName:@"output"] insert:widge];
    }
}

- (BOOL)allowConnectionWithMachine:(FGMachine *)machine
{
    for (FGConnectionPoint* cp in [self.connectionPointInputs arrayByAddingObjectsFromArray:self.connectionPointOutputs]) {
        if (cp.connector.source == machine || cp.connector.destination == machine) {
            return NO;  // don't connect to a machine that you've already connected to
        }
    }
    
    return YES;
}

@end
