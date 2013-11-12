//
//  FGGridOverlay.m
//  factory
//
//  Created by admin on 11/11/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGGridOverlay.h"

@implementation FGGridOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    CGContextSetLineWidth(context, 1.0);
    
    for (int x = 0; x <= WorldWidth; x += ZoneSize) {
        CGContextMoveToPoint(context, x, 0); //start at this point
        CGContextAddLineToPoint(context, x, WorldHeight); //draw to this point
        // and now draw the Path!
        CGContextStrokePath(context);
    }
    
    for (int y = 0; y <= WorldHeight; y += ZoneSize) {
        CGContextMoveToPoint(context, 0,y); //start at this point
        CGContextAddLineToPoint(context, WorldWidth, y); //draw to this point
        // and now draw the Path!
        CGContextStrokePath(context);
    }
}

@end
