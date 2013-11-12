//
//  FGUtil.m
//  factory
//
//  Created by admin on 11/11/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGUtil.h"

@implementation FGUtil

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