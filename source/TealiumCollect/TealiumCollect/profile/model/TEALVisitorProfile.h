//
//  TEALProfile.h
//  TEALAudienceStream
//
//  Created by George Webster on 1/5/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALProfileCurrentVisit.h"

@interface TEALVisitorProfile : NSObject <NSCoding, NSCopying>

/**
 *  Valid flag for Profile instance
 *
 *  @return YES if visitorID is valid, otherwise NO
 */
- (BOOL) isValid;

/**
 *  Visitor ID addociated with this profile
 *
 *  @return String representation of user's vistorID
 */
- (NSString *) visitorID;

/**
 *  Audiences this visitor's profile is associated with.
 *
 *  @return Array of TEALProfileAudienceAttribute objects or nil if none exist
 */
- (NSArray *) audiences;

/**
 *  Badges this visitor's profile is associated with.
 *
 *  @return Array of TEALProfileBadgeAttribute objects or nil if none exist
 */
- (NSArray *) badges;

/**
 *  Dates this visitor's profile is associated with.
 *
 *  @return Array of TEALProfileDateAttribute objects or nil if none exist
 */
- (NSArray *) dates;

/**
 *  Flags this visitor's profile is associated with.
 *
 *  @return Array of TEALProfileFlagAttribute objects or nil if none exist
 */
- (NSArray *) flags;

/**
 *  Metrics this visitor's profile is associated with.
 *
 *  @return Array of TEALProfileMetricAttribute objects or nil if none exist
 */
- (NSArray *) metrics;

/**
 *  Properties or "Traits" this visitor's profile is associated with.
 *
 *  @return Array of TEALProfilePropertyAttribute objects or nil if none exist
 */
- (NSArray *) properties;

@property (readonly, nonatomic) TEALProfileCurrentVisit *currentVisit;


/**
 *  Raw profile returned from AudienceStream.  JSON object converted to valid native objects
 *
 *  @return NSDictionary of raw profile objects
 */
- (NSDictionary *) rawProfile;

@end
