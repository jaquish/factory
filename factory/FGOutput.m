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
        UIColor *borderColor = [UIColor grayColor];
        UIColor *innerColor = [UIColor blueColor];
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:borderColor size:CGSizeMake(ZoneSize, ZoneSize)];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite];
        
        int inset = 5;
        SKSpriteNode *inner = [SKSpriteNode spriteNodeWithColor:innerColor size:CGSizeMake(ZoneSize - 2*inset, ZoneSize - 2*inset)];
        inner.anchorPoint = CGPointZero;
        inner.position = CGPointMake(inset, inset);
        [sprite addChild:inner];
        
        SKLabelNode *label = [SKLabelNode node];
        label.position = compassPointOfZone(center, FGZoneMake(0, 0));
        [self addChild:label];
        label.text = @"0";
        self.label = label;
        self.count = 0;
        
        // describe I/O
        [self addInput:[FGConnectionPoint pointWithPosition:compassPointOfZone(center, self.rootZone) name:@"input"]];
    }
    
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    for (FGWidge *widge in [self.connectors[@"input"] widges]) {
        [widge removeFromParent];
        self.count++;
    }
    self.label.text = [NSString stringWithFormat:@"%d", self.count];
}

@end
