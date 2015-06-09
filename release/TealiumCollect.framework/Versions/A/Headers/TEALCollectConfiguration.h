//
//  TEALCollectConfiguration.h
//  Tealium Collect Library
//
//  Created by George Webster on 3/2/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Configuration Types

typedef NS_ENUM(NSUInteger, TEALVisitorProfilePollingFrequency) {
    TEALVisitorProfilePollingFrequencyOnRequest = 1,
    TEALVisitorProfilePollingFrequencyAfterEveryEvent
};

typedef NS_ENUM(NSUInteger, TEALCollectLogLevel) {
    TEALCollectLogLevelNone = 1,
    TEALCollectLogLevelNormal,
    TEALCollectLogLevelVerbose,
    TEALCollectLogLevelExtremeVerbosity
};


@interface TEALCollectConfiguration : NSObject

@property (copy, nonatomic) NSString *accountName;
@property (copy, nonatomic) NSString *profileName;
@property (copy, nonatomic) NSString *environmentName;

@property (nonatomic) BOOL useHTTP;
@property (nonatomic) TEALVisitorProfilePollingFrequency pollingFrequency;
@property (nonatomic) TEALCollectLogLevel logLevel;

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
