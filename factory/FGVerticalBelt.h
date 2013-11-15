//
//  FGVerticalBelt.h
//  factory
//
//  Created by Zach Jaquish on 11/14/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGMachine.h"

@interface FGVerticalBelt : FGMachine

@property FGZone endZone;

- (id)initWithOriginZone:(FGZone)fromZone endZone:(FGZone)toZone;

@end
