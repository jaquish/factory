//
//  FGInput.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGInput.h"

@interface FGInput ()

@property (nonatomic) NSMutableArray *generated;

@end

@implementation FGInput

- (id)initWithRootZone:(FGZone)zone
{
    if (self = [super initWithRootZone:zone])
    {
        // ivars
        self.generated = [NSMutableArray array];
        
        // draw
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(ZoneSize, ZoneSize)];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite];
        
        // describe I/O
        FGConnectionPoint *cp = [[FGConnectionPoint alloc] init];
        cp.position = compassPointOfZone(center, self.rootZone);
        cp.name = @"next";
        cp.machine = self;
        [self.connectionPointOutputs addObject:cp];
    }
    
    return self;
}

- (void)generateWidge
{
    FGWidge *widge = [FGWidge redWidge];
    CGPoint generationPoint = compassPointOfZone(center, self.rootZone);
    widge.position = generationPoint;
    [self.generated addObject:widge];
    [self.scene addChild:widge];
}

- (void)render:(CFTimeInterval)_dt
{
    for (FGWidge* widge in self.generated) {
        [self.connectors[@"next"] insert:widge];
    }
    [self.generated removeAllObjects];
}

@end
