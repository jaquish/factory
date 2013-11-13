//
//  FGMachine.h
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGWidge.h"
#import "FGConnector.h"
#import "FGConnectionPoint.h"

@interface FGMachine : SKSpriteNode

// The most lower-left zone of the machine.
@property (nonatomic) FGZone rootZone;

// Lists of connection points for possible connectors
@property (nonatomic) NSMutableArray *connectionPointInputs;
@property (nonatomic) NSMutableArray *connectionPointOutputs;

// A list of connectors
@property (nonatomic) NSMutableDictionary *connectors;

// Root zone necessary to calculate connection point positions
- (id)initWithRootZone:(FGZone)zone;

// Called every frame
- (void)render:(CFTimeInterval)_dt;

// Move connectors from connection points into list
- (void)organizeConnectors;

@end
