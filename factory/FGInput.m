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

- (id)init
{
    if (self = [super init])
    {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(64, 64)];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite];
        
        self.generated = [NSMutableArray array];
    }
    
    return self;
}

- (void)generateWidge
{
    FGWidge *widge = [FGWidge redWidge];
    widge.position = CGPointMake(self.position.x + 32, self.position.y + 32);
    [self.generated addObject:widge];
    [self.scene addChild:widge];
}

- (void)render:(CFTimeInterval)_dt
{
    for (FGWidge* widge in self.generated) {
        [self.next insert:widge];
    }
    [self.generated removeAllObjects];
}

@end
