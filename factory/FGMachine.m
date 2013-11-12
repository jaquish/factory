//
//  FGMachine.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGMachine.h"
#import "FGConnector.h"

@interface FGMachine ()

@property (nonatomic) NSMutableArray *connectors;

@end

@implementation FGMachine

- (id)init
{
    if (self = [super init])
    {
        ;
    }
    
    return self;
}

- (void)render:(CFTimeInterval)_dt
{
    ;   // Do something!
}

- (void)propogate
{
    ;   // Do something!
}

@end
