//
//  FGConnector.m
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGConnector.h"
#import "FGMachine.h"

@interface FGConnector ()

@property (nonatomic) NSMutableArray *sourceList;
@property (nonatomic) NSMutableArray *destinationList;

@end

@implementation FGConnector

- (id)init
{
    if (self = [super init]) {
        self.sourceList = [NSMutableArray array];
        self.destinationList = [NSMutableArray array];
    }
    
    return self;
}

- (void)insert:(FGWidge *)widge
{
    [self.sourceList insertObject:widge atIndex:0];
}

- (void)propogate
{
    for (FGWidge *widge in [self.sourceList reverseObjectEnumerator]) {
        [self.destinationList insertObject:widge atIndex:0];
    }
    [self.sourceList removeAllObjects];
//    NSLog(@"Propogated %@", self);
}

- (NSArray*)dequeueWidges
{
    NSArray *copy = [self.destinationList copy];
    [self.destinationList removeAllObjects];
    return copy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Connector from %@ to %@", self.source.name, self.destination.name];
}

@end
