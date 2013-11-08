//
//  FGWidge.m
//  factory
//
//  Created by admin on 11/2/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGWidge.h"

const float kWidgeWidth = 40.0;


@implementation FGWidge

+ (instancetype)redWidge
{
    return [FGWidge widgeWithColor:[UIColor redColor]];
}

+ (instancetype)orangeWidge
{
    return [FGWidge widgeWithColor:[UIColor orangeColor]];
}

+ (instancetype)yellowWidge
{
    return [FGWidge widgeWithColor:[UIColor yellowColor]];
}

+ (instancetype)greenWidge
{
    return [FGWidge widgeWithColor:[UIColor greenColor]];
}

+ (instancetype)blueWidge
{
    return [FGWidge widgeWithColor:[UIColor blueColor]];
}

+ (instancetype)purpleWidge
{
    return [FGWidge widgeWithColor:[UIColor purpleColor]];
}

+ (instancetype)widgeWithColor:(UIColor*)color
{
    FGWidge *widge = [self spriteNodeWithColor:color size:CGSizeMake(kWidgeWidth, kWidgeWidth)];
    widge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:widge.size];
//    widge.physicsBody.dynamic = YES;
    widge.physicsBody.categoryBitMask = widgeCategory;
    widge.physicsBody.contactTestBitMask = tileCategory;
    widge.physicsBody.collisionBitMask = 0; // don't bounce off anything
    
    return widge;
}

@end
