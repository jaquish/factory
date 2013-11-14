//
//  FGMyScene.m
//  factory
//
//  Created by admin on 11/2/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGMyScene.h"
#import "FGWidge.h"
#import "FGMachine.h"
#import "FGBelt.h"
#import "FGGravity.h"
#import "FGInput.h"
#import "FGOutput.h"
#import "FGTransformer.h"

@interface FGMyScene ()
{
    CFTimeInterval _prevTime;
    CFTimeInterval _dt;
}

/* Lists */
@property (nonatomic) NSMutableArray *machines;

/* Temporary direct links */
@property (nonatomic) FGInput *input;

@end

@implementation FGMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];

        // ivar setup
        self.machines = [NSMutableArray array];
        
        // input
        FGInput *input = [[FGInput alloc] initWithOriginZone:FGZoneMake(3, 8)];
        input.name = @"input";
        self.input = input; // to tell when a touch occurred
        [self addMachine:input];
        
        // gravity
        FGGravity *gravity = [[FGGravity alloc] initWithOriginZone:FGZoneMake(3, 8) endZone:FGZoneMake(3, 2)];
        gravity.name = @"gravity1";
        [self addMachine:gravity];
        
        // belt
        FGBelt *belt = [[FGBelt alloc] initWithOriginZone:FGZoneMake(3, 2) endZone:FGZoneMake(8, 2)];
        belt.name = @"belt";
        [self addMachine:belt];
        
        // gravity part 2
        FGGravity *gravity2 = [[FGGravity alloc] initWithOriginZone:FGZoneMake(9, 2) endZone:FGZoneMake(9, 0)];
        gravity2.name = @"gravity2";
        [self addMachine:gravity2];
        
        // output
        FGOutput *output = [[FGOutput alloc] initWithOriginZone:FGZoneMake(9, 0)];
        output.name = @"output";
        [self addMachine:output];
        
        // transformer
        FGTransformer *transformer = [[FGTransformer alloc] initWithOriginZone:FGZoneMake(6, 2)];
        transformer.name = @"transformer";
        [self addMachine:transformer];
        
        [self makeConnections];
    }
    return self;
}

- (void)addMachine:(FGMachine*)machine
{
    [self.machines addObject:machine];
    [self addChild:machine];
}

- (void)makeConnections
{
    for (FGMachine *machines1 in self.machines) {
        for (FGConnectionPoint *output in machines1.connectionPointOutputs) {
            for (FGMachine *machines2 in self.machines) {
                for (FGConnectionPoint *input in machines2.connectionPointInputs) {
                    [output tryToConnectToPoint:input];
                }
            }
        }
    }
    
    for (FGMachine *machine in self.machines) {
        [machine organizeConnectors];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    [self.input generateWidge];
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    _dt = currentTime - _prevTime;
    
    for (FGMachine* machine in self.machines) {
        [machine render:_dt];
    }
    
    // propogate
    for (FGMachine *machine in self.machines) {
        for (FGConnector *connector in [machine.connectors allValues]) {    // efficiency - only do outputs?
            [connector propogate];
        }
    }
    
    /*** TODO - insert phase 2 processing here ***/
    
    _prevTime = currentTime;
}

@end
