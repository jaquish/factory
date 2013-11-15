//
//  FGConstants.h
//  factory
//
//  Created by admin on 11/3/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGConstants : NSObject

@end

/* iPad Constraints */
extern const float WorldHeight;
extern const float WorldWidth;

/* 2D World Constants */
extern const float ZoneSize;
extern const float WidgeSize;
extern const float ZonesWide;
extern const float ZonesHigh;

/* Sprite Layers */
extern const float SpriteLayerBackground;
extern const float SpriteLayerBehindWidges;
extern const float SpriteLayerWidges;
extern const float SpriteLayerInFrontOfWidges;

/* Debug Flags */
extern BOOL DEBUG_SHOW_GRID;

/* Other */
extern const float LabelFontSize;