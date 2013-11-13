//
//  FGOutput.m
//  factory
//
//  Created by admin on 11/11/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGOutput.h"

@interface FGOutput ()

@property (nonatomic) SKLabelNode *label;
@property (nonatomic) int count;

@end

@implementation FGOutput

- (id)initWithRootZone:(FGZone)zone
{
    if (self = [super initWithRootZone:zone])
    {
        // draw
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.1 green:0.7 blue:0.2 alpha:1.0] size:CGSizeMake(ZoneSize, ZoneSize)];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"ZZZ"];
        label.position = compassPointOfZone(center, FGZoneMake(0, 0));
        [self addChild:label];
        label.text = @"0";
        self.count = 0;
        
        // describe I/O
        FGConnectionPoint *input = [[FGConnectionPoint alloc] init];
        input.position = compassPointOfZone(center, self.rootZone);
        input.name = @"input";
        input.machine = self;
        [self.connectionPointInputs addObject:input];
    }
    
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    for (FGWidge *widge in self.connectors[@"input"]) {
        self.count++;
    }
}

@end
