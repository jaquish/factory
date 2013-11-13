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

// Connector is active during gameplay
@interface FGConnector : NSObject

@property (nonatomic) CGPoint position;

// Connectors have a source and a destination
@property (nonatomic) FGMachine *source;
@property (nonatomic) FGMachine *destination;

- (void)insert:(FGWidge*)widge;

- (void)propogate;

- (NSArray*)dequeueWidges;

@end


