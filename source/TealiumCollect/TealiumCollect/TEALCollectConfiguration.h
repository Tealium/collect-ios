//
//  TEALCollectConfiguration.h
//  Tealium Collect Library
//
//  Created by George Webster on 3/2/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Configuration Types

/**
 *  Unsigned integer value that controls the frequency at which the user's visitor profile is requested from AudienceStream
 */
typedef NS_ENUM(NSUInteger, TEALVisitorProfilePollingFrequency){
    /**
     *  On request only, will only poll AudienceStream with the fetchVisitorProfileWithCompletion: method
     */
    TEALVisitorProfilePollingFrequencyOnRequest = 1,
    /**
     *  After every event, after each sendEventWithData: or sendViewWithData: call an updated visitor profile will be requested.
     */
    TEALVisitorProfilePollingFrequencyAfterEveryEvent
};

/**
 *  Unsigned integer value that controls the level of logging will use during its lifecycle.
 */
typedef NS_ENUM(NSUInteger, TEALCollectLogLevel){
    /**
     *  Nothing is logged to the concole, this is the default.
     */
    TEALCollectLogLevelNone = 1,
    /**
     *  Normal is minimal informative feedback of events processed and requested task status
     */
    TEALCollectLogLevelNormal,
    /**
     *  Verbose is a more verbose version of normal, expanded logs for each event.  Useful for debugging and verifing during development.
     */
    TEALCollectLogLevelVerbose,
    /**
     *  Extremely Verbose will display everything from Verbose with more gross details such has the complete contents of NSURLRequests and their responses.
     */
    TEALCollectLogLevelExtremeVerbosity
};


/**
 *  Configuration Class for the Tealium Collect Library
 *  An instance of this is passed to TealiumCollect enableWithConfiguration: to start the Collect Library
 */
@interface TEALCollectConfiguration : NSObject

/**
 *  Tealium iQ account name
 */
@property (copy, nonatomic) NSString *accountName;

/**
 *  Tealium iQ profile name, this should be the TiQ profile where the mobile publish settings have been configured for the collect library.
 *
 *  Note: This is usually not the same profile used for AudienceStream
 *  @see audienceStreamProfile
 */
@property (copy, nonatomic) NSString *profileName;

/**
 *  Tealium iQ evnvironment name.
 *
 *  @example dev/qa/prod
 */
@property (copy, nonatomic) NSString *environmentName;

/**
 *  Flag when on will send all data for HTTP.  Suggested to be used in development only!
 *
 *  @default NO
 */
@property (nonatomic) BOOL useHTTP;

/**
 *  Frequency at which visitor profile should be polled.  
 *  By default after each sendEventWithData: and sendViewWithData: call an updated visitor profile will be requested.
 *  If set to on request, the library will only requery the profile when asked for using fetchVisitorProfileWithCompletion:
 *
 *  @default TEALVisitorProfilePollingFrequencyAfterEveryEvent
 *  @see TEALVisitorProfilePollingFrequency
 */
@property (nonatomic) TEALVisitorProfilePollingFrequency pollingFrequency;

/**
 *  How verbose the library's logs should be.  This defaults to showing nothing.
 *
 *  @default TEALCollectLogLevelNone
 *  @see TEALCollectLogLevel
 */
@property (nonatomic) TEALCollectLogLevel logLevel;

/**
 *  Profile name Collect should use to query AudienceStream with.  Usually this is the account's main profile, however if a different profile is desired that profile's name goes here.
 *
 *  @default "main"
 */
@property (copy, nonatomic) NSString *audienceStreamProfile;

/**
 *  Creates a default configration instance for a given account / profile / environment combination.  The TiQ information is used to fetch the profile's mobile publish settings used
 *
 *  @param accountName     String of TiQ / AudienceStream account name
 *  @param profileName     String of TiQ Profile Name
 *  @param environmentName String
 *
 *  @return Valid configuration instance to pass to the enableWithConfiguration: method.
 */
+ (instancetype) configurationWithAccount:(NSString *)accountName
                                  profile:(NSString *)profileName
                              environment:(NSString *)environmentName;


@end
