//
//  FGMyScene.m
//  factory
//
//  Created by admin on 11/2/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGMyScene.h"
#import "FGWidge.h"
#import "FGTile.h"
#import "FGMachine.h"
#import "FGGravity.h"

@interface FGMyScene ()
{
    CFTimeInterval _prevTime;
    CFTimeInterval _dt;
}

@property (nonatomic) NSMutableArray *machines;
@property (nonatomic) FGGravity *gravity;

@end

@implementation FGMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.machines = [NSMutableArray array];
        self.gravity = [[FGGravity alloc] init];
        [self.machines addObject:self.gravity];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // belts
        for (int i = 1; i <= 5; i++) {
            [self addBeltAtZone:CGPointMake(i, 3)];
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        FGWidge *widge = [FGWidge redWidge];
        
        widge.position = location;
        
        [self addChild:widge];
        [self.gravity add:widge];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    _dt = currentTime - _prevTime;
    
    for (FGMachine* machine in self.machines) {
        [machine render:_dt];
    }
    
    // propogate
    for (FGMachine* machine in self.machines) {
        [machine propogate];
    }
    
    // TODO - insert phase 2 processing here
    
    _prevTime = currentTime;
}

- (void)addBeltAtZone:(CGPoint)zone
{
    FGTile *tile = [FGTile beltEast];
    tile.anchorPoint = CGPointZero; // position tile from lower left
    tile.position = CGPointMake(64 * zone.x, 64 * zone.y);
    [self addChild:tile];
}

- (void)widge:(FGWidge*)widge didCollideWithTile:(FGTile*)tile
{
    CGPoint pos = widge.position;
    pos.y += 300.0;
    widge.position = pos;
}

@end
