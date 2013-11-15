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
#import "FGTransferBox.h"
#import "FGVerticalBelt.h"

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
        FGInput *input = [[FGInput alloc] initWithOriginZone:FGZoneMake(2, 8)];
        input.name = @"input";
        self.input = input; // to tell when a touch occurred
        [self addMachine:input];
        
        // gravity
        FGGravity *gravity = [[FGGravity alloc] initWithOriginZone:FGZoneMake(2, 8) endZone:FGZoneMake(2, 2)];
        gravity.name = @"gravity1";
        [self addMachine:gravity];
        
        // belt
        FGBelt *belt = [[FGBelt alloc] initWithOriginZone:FGZoneMake(2, 2) endZone:FGZoneMake(7, 2)];
        belt.name = @"belt";
        [self addMachine:belt];
        
        // transformer
        FGTransformer *transformer = [[FGTransformer alloc] initWithOriginZone:FGZoneMake(4, 2) color:[UIColor yellowColor]];
        transformer.name = @"transformer";
        [self addMachine:transformer];
        
        // transformer
        FGTransformer *transformer2 = [[FGTransformer alloc] initWithOriginZone:FGZoneMake(6, 2) color:[UIColor greenColor]];
        transformer.name = @"transformer-2";
        [self addMachine:transformer2];
        
        // transfer box
        FGTransferBox *transferBox = [[FGTransferBox alloc] initWithOriginZone:FGZoneMake(8, 2)];
        transferBox.name = @"transfer-box";
        [self addMachine:transferBox];
        
        // vertical belt
        FGVerticalBelt *vertical = [[FGVerticalBelt alloc] initWithOriginZone:FGZoneMake(8, 2) endZone:FGZoneMake(8, 7)];
        vertical.name = @"vertical";
        [self addMachine:vertical];
        
        // transfer box 2
        FGTransferBox *transferBox2 = [[FGTransferBox alloc] initWithOriginZone:FGZoneMake(8, 7)];
        transferBox.name = @"transfer-box-2";
        [self addMachine:transferBox2];
        
        // belt 2
        FGBelt *belt2 = [[FGBelt alloc] initWithOriginZone:FGZoneMake(8, 7) endZone:FGZoneMake(11, 7)];
        belt.name = @"belt-2";
        [self addMachine:belt2];
        
        // gravity part 2
        FGGravity *gravity2 = [[FGGravity alloc] initWithOriginZone:FGZoneMake(12, 7) endZone:FGZoneMake(12, 0)];
        gravity2.name = @"gravity2";
        [self addMachine:gravity2];
        
        // output
        FGOutput *output = [[FGOutput alloc] initWithOriginZone:FGZoneMake(12, 0)];
        output.name = @"output";
        [self addMachine:output];
        
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
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO];
    
    // get outputs in sorted priority order
    NSMutableArray *allOutputs = [NSMutableArray array];
    for (FGMachine *machine in self.machines) {
        [allOutputs addObjectsFromArray:machine.connectionPointOutputs];
    }
    [allOutputs sortUsingDescriptors:@[sorter]];
    
    // get inputs in sorted priority order
    NSMutableArray *allInputs  = [NSMutableArray array];
    for (FGMachine *machine in self.machines) {
        [allInputs addObjectsFromArray:machine.connectionPointInputs];
    }
    [allInputs sortUsingDescriptors:@[sorter]];
    
    // shotgun connections
    for (FGConnectionPoint *output in allOutputs) {
        for (FGConnectionPoint *input in allInputs) {
            [output tryToConnectToPoint:input];
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
        [machine update:_dt];
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
