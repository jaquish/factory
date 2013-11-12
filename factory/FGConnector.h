//
//  FGConnector.h
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGWidge.h"

@class FGMachine;

@interface FGConnector : NSObject

@property (nonatomic) CGPoint position;

@property (nonatomic) FGMachine *input;
@property (nonatomic) FGMachine *output;

- (void)insert:(FGWidge*)widge;

- (void)propogate;

- (NSArray*)widges;

@end
