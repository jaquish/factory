//
//  FGInput.h
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import "FGMachine.h"

@interface FGInput : FGMachine

@property (nonatomic) FGConnector *next;

- (void)generateWidge;

@end
