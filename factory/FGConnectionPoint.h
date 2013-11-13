//
//  FGConnectionPoint.h
//  factory
//
//  Created by admin on 11/12/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGConnector.h"
#include "FGMachine.h"

@interface FGConnectionPoint : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) FGConnector *connector;   // if null, connection point has not been connected
@property (nonatomic) FGMachine *machine;
@property (nonatomic) NSString *name;

- (void)tryToConnectToPoint:(FGConnectionPoint*)point;

@end
