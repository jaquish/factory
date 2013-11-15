//
//  FGConnectionPoint.h
//  factory
//
//  Created by admin on 11/12/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const unsigned int kConnectionPointPriorityHigh;

// fix for circular referencing
@class FGMachine;
@class FGConnectionPoint;
@class FGConnector;

@interface FGConnectionPoint : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) FGConnector *connector;   // if null, connection point has not been connected
@property (nonatomic) FGMachine *machine;
@property (nonatomic) NSString *name;
@property (nonatomic) unsigned int priority;

+ (instancetype)pointWithPosition:(CGPoint)position name:(NSString*)name;

- (void)tryToConnectToPoint:(FGConnectionPoint*)point;

@end
