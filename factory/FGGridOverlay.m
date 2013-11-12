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
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0);
    
    for (int x = 0; x < 1024; x += 64) {
        CGContextMoveToPoint(context, x, 0); //start at this point
        CGContextAddLineToPoint(context, x, 768); //draw to this point
        // and now draw the Path!
        CGContextStrokePath(context);
    }
    
    for (int y = 0; y < 768; y += 64) {
        CGContextMoveToPoint(context, 0,y); //start at this point
        CGContextAddLineToPoint(context, 1024, y); //draw to this point
        // and now draw the Path!
        CGContextStrokePath(context);
    }
}

@end
