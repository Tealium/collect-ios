//
//  TEALVisitorProfile+PrivateHeader.h
//  Tealium Collect Library
//
//  Created by George Webster on 2/10/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfile.h"
#import "TEALVisitorProfileCurrentVisit.h"

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

@property (readwrite) NSInteger totalEventCount;

@end
