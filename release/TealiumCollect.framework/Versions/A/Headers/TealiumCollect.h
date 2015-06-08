//
//  TealiumCollect.h
//  Tealium Collect Library
//
//  Created by George Webster on 1/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//
//  Version 0.5

#import <Foundation/Foundation.h>
#import "TEALVisitorProfile.h"
#import "TEALCollectConfiguration.h"
#import <TealiumUtilities/TEALBlocks.h>
#import "TEALEvent.h"


@interface TealiumCollect : NSObject

# pragma mark - Setup / Configuration

/**
 *  Starts the AudienceStream Library with the given configuration object.
 *
 *  @param configuration TEALAudienceStreamConfiguration instance with valid Account/Profile/Enviroment properties.
 */
+ (void) enableWithConfiguration:(TEALCollectConfiguration *)configuration;

/**
 *  Starts the AudienceStream Library with the given configuration object.
 *
 *  @param configuration TEALAudienceStreamConfiguration instance with valid Account/Profile/Enviroment properties.
 *  @param completion    TEALBooleanCompletionBlock which is called after settings have loaded and visitorID has been created or restored.
 */
+ (void) enableWithConfiguration:(TEALCollectConfiguration *)configuration
                      completion:(TEALBooleanCompletionBlock)completion;

/**
 *  Disabled the library from operating.  Sets the libraries internal state to disabled, all subsequent method calls with be ignored.
 */
+ (void) disable;

# pragma mark - Send AudienceStream Data

/**
 *  Sends an event to AudienceStream.  Event are packaged with any custom key/value data sources passed in along with the default datasources provided by the library.
 *
 *  @param customData Dictionary of custom datasources (key/value pairs) to be included in the event dispatch.
 */
+ (void) sendEventWithData:(NSDictionary *)customData;

/**
 *  Sends a view to AudienceStream.  Views are packaged with any custom key/value data sources passed in along with the default datasources provided by the library.
 *
 *  @param customData Dictionary of custom datasources (key/value pairs) to be included in the event dispatch.
 */

+ (void) sendViewWithData:(NSDictionary *)customData;

# pragma mark - Get AudienceStream Data

/**
 *  Retrieves the current visitor profile from AudienceStream.
 *
 *  @param completion Completion block with retrieved TEALProfile instance and an error should any problems occur.
 */
+ (void) fetchVisitorProfileWithCompletion:(void (^)(TEALVisitorProfile *profile, NSError *error))completion;

/**
 *  Last retrieved profile instance.  This is updated every time the profile is queried.  Depending on the settings the library was enabled with, this could be after every sendEvent:customData: call or only on explicit request.
 *
 *  @return Returns valid TEALProfile object.  Its properties might be nil of nothing is loaded into them yet.
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
