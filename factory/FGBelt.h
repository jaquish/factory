//
//  FGBelt.h
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGMachine.h"

@interface FGBelt : FGMachine

@property (nonatomic) FGConnector *input;
@property (nonatomic) FGConnector *output;

@property CGPoint startZone;
@property CGPoint endZone;

@end
