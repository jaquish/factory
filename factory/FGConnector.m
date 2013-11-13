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

@property (nonatomic) NSMutableArray *outList;
@property (nonatomic) NSMutableArray *inList;

@end

@implementation FGConnector

- (id)init
{
    if (self = [super init]) {
        self.outList = [NSMutableArray array];
        self.inList = [NSMutableArray array];
    }
    
    return self;
}

- (void)insert:(FGWidge *)widge
{
    [self.outList insertObject:widge atIndex:0];
}

- (void)propogate
{
    for (FGWidge *widge in [self.outList reverseObjectEnumerator]) {
        [self.inList insertObject:widge atIndex:0];
    }
    [self.outList removeAllObjects];
    NSLog(@"Propogated %@", self);
}

- (NSArray*)widges
{
    return [self.outList copy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Connector from %@ to %@", self.source.name, self.destination.name];
}

@end
