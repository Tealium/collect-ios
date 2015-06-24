//
//  TEALVisitorProfile+PrivateHeader.h
//  Tealium Collect Library
//
//  Created by George Webster on 2/10/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfile.h"
#import "TEALVisitorProfileCurrentVisit.h"

#import "TEALVisitorProfileBaseAttribute.h"
#import "TEALVisitorProfileAudienceAttribute.h"
#import "TEALVisitorProfileBadgeAttribute.h"
#import "TEALVisitorProfileDateAttribute.h"
#import "TEALVisitorProfileFlagAttribute.h"
#import "TEALVisitorProfileMetricAttribute.h"
#import "TEALVisitorProfilePropertyAttribute.h"

@interface TEALVisitorProfile (PrivateHeader)

@property (copy, readwrite) NSString *visitorID;

@property (readwrite, nonatomic) NSDictionary *rawProfile;

@property (readwrite, nonatomic) NSArray *audiences;
@property (readwrite, nonatomic) NSArray *badges;
@property (readwrite, nonatomic) NSArray *dates;
@property (readwrite, nonatomic) NSArray *flags;
@property (readwrite, nonatomic) NSArray *metrics;
@property (readwrite, nonatomic) NSArray *properties;

@property (readwrite, nonatomic) TEALVisitorProfileCurrentVisit *currentVisit;


/**
 *  AudienceStream visitor profile object.
 *
 *  @param visitorID String unique identifier, currently UUID with "-"'s stripped out.
 *
 *  @return valid profile object.
 */
- (instancetype) initWithVisitorID:(NSString *)visitorID;

@end

@interface TEALVisitorProfileCurrentVisit (PrivateHeader)

- (void) storeRawCurrentVisit:(NSDictionary *)rawProfile;

@property (readwrite) NSTimeInterval creationTimestamp;

@property (readwrite, nonatomic) NSArray *dates;
@property (readwrite, nonatomic) NSArray *flags;
@property (readwrite, nonatomic) NSArray *metrics;
@property (readwrite, nonatomic) NSArray *properties;

@property (readwrite) NSUInteger totalEventCount;

@end

#pragma mark - Attributes

@interface TEALVisitorProfileBaseAttribute (PrivateHeader)

@property (readwrite, copy, nonatomic) NSString *attributeID;
@property (readonly) TEALVisitorProfileAttributeType type;

+ (instancetype) profileAttributeWithType:(TEALVisitorProfileAttributeType)type;

- (instancetype) initWithType:(TEALVisitorProfileAttributeType)type;

@end

@interface TEALVisitorProfileAudienceAttribute (PrivateHeader)

@property (readwrite, copy, nonatomic) NSString *name;

@end

@interface TEALVisitorProfileBadgeAttribute (PrivateHeader)

@property (readwrite, copy, nonatomic) NSString *name;

@end

@interface TEALVisitorProfileDateAttribute (PrivateHeader)

@property (readwrite, nonatomic) NSTimeInterval timestamp;

@end

@interface TEALVisitorProfileFlagAttribute (PrivateHeader)

@property (readwrite, nonatomic) BOOL value;

@end

@interface TEALVisitorProfileMetricAttribute (PrivateHeader)

@property (readwrite, nonatomic) float value;

@end

@interface TEALVisitorProfilePropertyAttribute (PrivateHeader)

@property (readwrite, copy, nonatomic) NSString *value;

@end




