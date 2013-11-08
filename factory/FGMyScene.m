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

@implementation FGMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // belts
        for (int i = 1; i <= 5; i++) {
            [self addBeltAtZone:CGPointMake(i, 3)];
        }
            
        // physics
        self.physicsWorld.contactDelegate = self;
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
    }
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)addBeltAtZone:(CGPoint)zone
{
    FGTile *tile = [FGTile beltEast];
    tile.anchorPoint = CGPointZero; // position tile from lower left
    tile.position = CGPointMake(64 * zone.x, 64 * zone.y);
    [self addChild:tile];
}

- (void)DUDE
{
    NSLog(@"!!!");
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & widgeCategory) != 0 &&
        (secondBody.categoryBitMask & tileCategory) != 0)
    {
        [self widge:(FGWidge*)firstBody.node didCollideWithTile:(FGTile*)secondBody.node];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    ;
}

- (void)widge:(FGWidge*)widge didCollideWithTile:(FGTile*)tile
{
    CGPoint pos = widge.position;
    pos.y += 300.0;
    widge.position = pos;
}

@end
