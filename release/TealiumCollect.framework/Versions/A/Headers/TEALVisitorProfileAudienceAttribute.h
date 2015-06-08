//
//  TEALVisitorProfileAudienceAttribute.h
//  Tealium Collect Library
//
//  Created by George Webster on 6/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALVisitorProfileBaseAttribute.h"

@interface TEALVisitorProfileAudienceAttribute : TEALVisitorProfileBaseAttribute <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *name;

@end
