//
//  FGMachine.h
//  factory
//
//  Created by admin on 11/7/13.
//  Copyright (c) 2013 Zach Jaquish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGWidge.h"

@interface FGMachine : NSObject

- (void)render:(CFTimeInterval)_dt;
- (void)propogate;

@end
