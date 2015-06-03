//
//  TEALProfileHelpers.h
//  ASTester
//
//  Created by George Webster on 3/10/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALProfileAttribute.h"

@class TEALVisitorProfile;

typedef TEALProfileAttribute * (^TEALProfileAttributeCreationBlock)(id key, id obj);

typedef void (^TEALProfileCompletionBlock)(TEALVisitorProfile *profile, NSError *error);


@interface TEALProfileHelpers : NSObject

+ (NSArray *) arrayOfAttrubutesForType:(TEALProfileAttributeType)type
                            fromSource:(NSDictionary *)sourceProfile
                             withBlock:(TEALProfileAttributeCreationBlock)block;

+ (NSString *)keypathForAttributeType:(TEALProfileAttributeType)type;

+ (NSArray *) arrayOfAudiencesFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfBadgesFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfDatesFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfFlagsFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfMetricsFromSource:(NSDictionary *)source;

+ (NSArray *) arrayOfPropertiesFromSource:(NSDictionary *)source;

@end
