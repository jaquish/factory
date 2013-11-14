//
//  FGBelt.h
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGMachine.h"

@interface FGBelt : FGMachine

@property FGZone endZone;

- (id)initWithOriginZone:(FGZone)fromZone endZone:(FGZone)toZone;

@end
