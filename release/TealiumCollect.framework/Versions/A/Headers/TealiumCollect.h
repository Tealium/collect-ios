//
//  Tealium Collect Library.h
//  Tealium Collect Library
//
//  Created by George Webster on 1/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//
//  Version 0.5

#import <Foundation/Foundation.h>

// Configuration

#import "TEALCollectConfiguration.h"

// Profile

#import "TEALVisitorProfile.h"
#import "TEALVisitorProfileCurrentVisit.h"

// Attributes:

#import "TEALVisitorProfileBaseAttribute.h"
#import "TEALVisitorProfileAudienceAttribute.h"
#import "TEALVisitorProfileBadgeAttribute.h"
#import "TEALVisitorProfileDateAttribute.h"
#import "TEALVisitorProfileFlagAttribute.h"
#import "TEALVisitorProfileMetricAttribute.h"
#import "TEALVisitorProfilePropertyAttribute.h"

#import <TealiumUtilities/TEALBlocks.h>

@interface TealiumCollect : NSObject

# pragma mark - Setup / Configuration

/**
 *  Starts the Tealium Collect Library with the given configuration object.
 *
 *  @param configuration TEALCollectConfiguration instance with valid Account/Profile/Enviroment properties.
 */
+ (void) enableWithConfiguration:(TEALCollectConfiguration *)configuration;

/**
 *  Starts the Tealium Collect Library with the given configuration object.
 *
 *  @param configuration TEALCollectConfiguration instance with valid Account/Profile/Enviroment properties.
 *  @param completion    TEALBooleanCompletionBlock which is called after settings have loaded and visitorID has been created or restored.
 */
+ (void) enableWithConfiguration:(TEALCollectConfiguration *)configuration
                      completion:(TEALBooleanCompletionBlock)completion;

/**
 *  Disabled the library from operating.  Sets the libraries internal state to disabled, all subsequent method calls with be ignored.
 */
+ (void) disable;

# pragma mark - Send Collect Data

/**
 *  Sends an event to Collect.  Event are packaged with any custom key/value data sources passed in along with the default datasources provided by the library.
 *
 *  @param customData Dictionary of custom datasources (key/value pairs) to be included in the event dispatch.
 */
+ (void) sendEventWithData:(NSDictionary *)customData;

/**
 *  Sends a view to Collect.  Views are packaged with any custom key/value data sources passed in along with the default datasources provided by the library.
 *
 *  @param customData Dictionary of custom datasources (key/value pairs) to be included in the event dispatch.
 */

+ (void) sendViewWithData:(NSDictionary *)customData;

# pragma mark - Get Collect Data

/**
 *  Retrieves the current visitor profile from AudienceStream.
 *
 *  @param completion Completion block with retrieved TEALVisitorProfile instance and an error should any problems occur.
 */
+ (void) fetchVisitorProfileWithCompletion:(void (^)(TEALVisitorProfile *profile, NSError *error))completion;

/**
 *  Last retrieved profile instance.  This is updated every time the profile is queried.  Depending on the settings the library was enabled with, this could be after every sendEvent:customData: call or only on explicit request.
 *
 *  @return Returns valid TEALVisitorProfile object.  Its properties might be nil of nothing is loaded into them yet.
 */
+ (TEALVisitorProfile *) cachedVisitorProfileCopy;

/**
 *  Unique visitor ID per Account / Device combination.
 *
 *  @return String value of the visitorID for the Account the library was enabled with.
 */
+ (NSString *) visitorID;

#pragma mark - Trace

/**
 *  Joins a trace initiated from the AudienceStream web app with a valid string token provide from the TraceUI
 *
 *  @param token String value should match the code provided via the AudienceStream web UI.
 */
+ (void) joinTraceWithToken:(NSString *)token;

/**
 *  Stops sending trace data for the provided token in the joinTraceWithToken: method.
 */
+ (void) leaveTrace;

@end
