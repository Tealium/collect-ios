//
//  TEALCollectConfiguration.h
//  Tealium Collect Library
//
//  Created by George Webster on 3/2/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Configuration Types

typedef NS_ENUM(NSUInteger, TEALProfilePollingFrequency) {
    TEALProfilePollingFrequencyOnRequest = 1,
    TEALProfilePollingFrequencyAfterEveryEvent
};

typedef NS_ENUM(NSUInteger, TEALConnectLogLevel) {
    TEALConnectLogLevelNone = 1,
    TEALConnectLogLevelNormal,
    TEALConnectLogLevelVerbose,
    TEALConnectLogLevelExtremeVerbosity
};


@interface TEALCollectConfiguration : NSObject

@property (copy, nonatomic) NSString *accountName;
@property (copy, nonatomic) NSString *profileName;
@property (copy, nonatomic) NSString *environmentName;

@property (nonatomic) BOOL useHTTP;
@property (nonatomic) TEALProfilePollingFrequency pollingFrequency;
@property (nonatomic) TEALConnectLogLevel logLevel;

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
