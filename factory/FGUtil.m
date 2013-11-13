//
//  FGUtil.m
//  factory
//
//  Created by admin on 11/11/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGUtil.h"

const static float kBorderInset = 5.0;

@implementation FGUtil

+ (SKSpriteNode *)zoneBoxWithColor:(UIColor *)color
{
    SKSpriteNode *box = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(ZoneSize, ZoneSize)];
    box.anchorPoint = CGPointZero;
    return box;
}

+ (SKSpriteNode *)zoneBoxWithBorder:(UIColor *)borderColor innerColor:(UIColor *)innerColor
{
    SKSpriteNode *box = [SKSpriteNode spriteNodeWithColor:borderColor size:CGSizeMake(ZoneSize, ZoneSize)];
    box.anchorPoint = CGPointZero;
    
    SKSpriteNode *inner = [SKSpriteNode spriteNodeWithColor:innerColor size:CGSizeMake(ZoneSize - 2*kBorderInset, ZoneSize - 2*kBorderInset)];
    inner.anchorPoint = CGPointZero;
    inner.position = CGPointMake(kBorderInset, kBorderInset);
    [box addChild:inner];
    
    return box;
}

@end

CGPoint compassPointOfZone(CompassPoint cp, FGZone z)
{
    switch (cp) {
        case N:     return CGPointMake(ZoneSize * (z.x + 0.5), ZoneSize * (z.y + 1.0));
        case NE:    return CGPointMake(ZoneSize * (z.x + 1.0), ZoneSize * (z.y + 1.0));
        case E:     return CGPointMake(ZoneSize * (z.x + 1.0), ZoneSize * (z.y + 0.5));
        case SE:    return CGPointMake(ZoneSize * (z.x + 1.0), ZoneSize * (z.y      ));
        case S:     return CGPointMake(ZoneSize * (z.x + 0.5), ZoneSize * (z.y      ));
        case SW:    return CGPointMake(ZoneSize * (z.x      ), ZoneSize * (z.y      ));
        case W:     return CGPointMake(ZoneSize * (z.x      ), ZoneSize * (z.y + 0.5));
        case NW:    return CGPointMake(ZoneSize * (z.x      ), ZoneSize * (z.y + 1.0));
        case center:return CGPointMake(ZoneSize * (z.x + 0.5), ZoneSize * (z.y + 0.5));
    }    
}

CGPoint centerOf(FGZone z)
{
    return compassPointOfZone(center, z);
}

FGZone zoneInDirectionFromZone(CompassPoint cp, FGZone z)
{
    switch (cp) {
        case N:     return FGZoneMake(z.x    , z.y + 1);
        case NE:    return FGZoneMake(z.x + 1, z.y + 1);
        case E:     return FGZoneMake(z.x + 1, z.y    );
        case SE:    return FGZoneMake(z.x + 1, z.y - 1);
        case S:     return FGZoneMake(z.x    , z.y - 1);
        case SW:    return FGZoneMake(z.x - 1, z.y - 1);
        case W:     return FGZoneMake(z.x - 1, z.y    );
        case NW:    return FGZoneMake(z.x - 1, z.y + 1);
        case center:return z;
    }
}

FGZone FGZoneMake(int x, int y)
{
    FGZone z;
    z.x = x;
    z.y = y;
    return z;
}

@implementation SKNode (FGExtensions)

- (void)changeXBy:(float)deltaX
{
    CGPoint pos = self.position;
    pos.x += deltaX;
    self.position = pos;
}

- (void)changeXTo:(float)x
{
    CGPoint pos = self.position;
    pos.x = x;
    self.position = pos;
}

- (void)changeYBy:(float)deltaY
{
    CGPoint pos = self.position;
    pos.y += deltaY;
    self.position = pos;
}

- (void)changeYTo:(float)y
{
    CGPoint pos = self.position;
    pos.y = y;
    self.position = pos;
}


@end