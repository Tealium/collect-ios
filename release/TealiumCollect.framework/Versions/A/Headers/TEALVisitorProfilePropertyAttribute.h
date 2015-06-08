//
//  TEALVisitorProfilePropertyAttribute.h
//  Tealium Collect Library
//
//  Created by George Webster on 6/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//
//
//  Personal information about the user.
//  also know as a "Trait" via the AS Web App.

#import <Foundation/Foundation.h>

#import "TEALVisitorProfileBaseAttribute.h"

@interface TEALVisitorProfilePropertyAttribute : TEALVisitorProfileBaseAttribute <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *value;

@end
