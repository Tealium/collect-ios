//
//  TEALVisitorProfileHelpers.h
//  Tealium Collect Library
//
//  Created by George Webster on 3/10/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALVisitorProfileBaseAttribute.h"

@class TEALVisitorProfile;

typedef TEALVisitorProfileBaseAttribute * (^TEALVisitorProfileAttributeCreationBlock)(id key, id obj);
 
typedef void (^TEALVisitorProfileCompletionBlock)(TEALVisitorProfile *profile, NSError *error);


@interface TEALVisitorProfileHelpers : NSObject

+ (NSArray *) arrayOfAttrubutesForType:(TEALVisitorProfileAttributeType)type
                            fromSource:(NSDictionary *)sourceProfile
                             withBlock:(TEALVisitorProfileAttributeCreationBlock)block;

+ (NSString *) keypathForAttributeType:(TEALVisitorProfileAttributeType)type;

+ (NSArray *) arrayOfAudiencesFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfBadgesFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfDatesFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfFlagsFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfMetricsFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfPropertiesFromSource:(NSDictionary *)source;

@end
