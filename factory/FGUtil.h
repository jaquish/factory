//
//  FGUtil.h
//  factory
//
//  Created by admin on 11/11/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface FGUtil : NSObject

@end

typedef CGPoint FGZone;

typedef enum { N, NE, E, SE, S, SW, W, NW, center } CompassPoint;

// return the compass point of the zone in
CGPoint compassPointOfZone(CompassPoint cp, FGZone z);

// represents a zone
FGZone FGZoneMake(int x, int y);


@interface SKNode (FGExtensions)

- (void)changeXBy:(float)deltaX;
- (void)changeXTo:(float)x;
- (void)changeYBy:(float)deltaY;
- (void)changeYTo:(float)y;

@end