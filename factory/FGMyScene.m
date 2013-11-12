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

@interface FGMyScene ()
{
    CFTimeInterval _prevTime;
    CFTimeInterval _dt;
}

/* Lists */
@property (nonatomic) NSMutableArray *machines;
@property (nonatomic) NSMutableArray *connectors;

/* Temporary direct links */
@property (nonatomic) FGInput *input;

@end

@implementation FGMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        // ivar setup
        self.machines = [NSMutableArray array];
        self.connectors = [NSMutableArray array];
        
        // input
        self.input = [[FGInput alloc] init];
        self.input.rootZone = FGZoneMake(3, 8);
        [self.machines addObject:self.input];
        [self addChild:self.input];
        
        // gravity
        FGGravity *gravity1 = [[FGGravity alloc] init];
        [self.machines addObject:gravity1];
        
        // connect input to gravity
        FGConnector *toGrav = [[FGConnector alloc] init];
        toGrav.position = self.input.position;  // set connection position is important
        self.input.next = toGrav;
        gravity1.input = toGrav;
        toGrav.input = self.input;
        toGrav.output = gravity1;
        [self.connectors addObject:toGrav];
        
        // belt
        FGBelt *belt = [[FGBelt alloc] initFromRootZone:FGZoneMake(3, 3) toZone:FGZoneMake(7, 3)];
        [self addChild:belt];
        [self.machines addObject:belt];
        
        // connect gravity to belt
        FGConnector *toBelt = [[FGConnector alloc] init];
        toBelt.position = CGPointMake(64 * 3.5, 64 * 3 + 12 + 20);    // set belt position is important
        gravity1.output = toBelt;
        belt.input = toBelt;
        [self.connectors addObject:toBelt];
        
        // gravity2
        FGGravity *gravity2 = [[FGGravity alloc] init];
        [self.machines addObject:gravity2];
        
        // connect belt to gravity
        FGConnector *toGrav2 = [[FGConnector alloc] init];
        toGrav2.position = compassPointOfZone(center, belt.endZone);
        belt.output = toGrav2;
        toGrav2.input = belt;
        toGrav2.output = gravity2;
        gravity2.input = toGrav2;
        [self.connectors addObject:toGrav2];
        
        // output
        FGOutput *output = [[FGOutput alloc] init];
        output.position = compassPointOfZone(SW, FGZoneMake(8, 0));
        [self addChild:output];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
    for (FGConnector* connector in self.connectors) {
        [connector propogate];
    }
    
    /*** TODO - insert phase 2 processing here ***/
    
    _prevTime = currentTime;
}


@end
