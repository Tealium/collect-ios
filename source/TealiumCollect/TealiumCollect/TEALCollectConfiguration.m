//
//  TEALCollectConfiguration.m
//  Tealium Collect Library
//
//  Created by George Webster on 3/2/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALCollectConfiguration.h"

@implementation TEALCollectConfiguration

+ (instancetype) configurationWithAccount:(NSString *)accountName
                                  profile:(NSString *)profileName
                              environment:(NSString *)environmentName {
    
    TEALCollectConfiguration *configuration = [[TEALCollectConfiguration alloc] init];
    
    if (!configuration) {
        return nil;
    }
    
    configuration.accountName       = accountName;
    configuration.profileName       = profileName;
    configuration.environmentName   = environmentName;
    configuration.useHTTP           = NO;
    configuration.pollingFrequency  = TEALProfilePollingFrequencyAfterEveryEvent;
    configuration.logLevel          = TEALCollectLogLevelNone;
   
    configuration.audienceStreamProfile = @"main";
    
    return configuration;
}

@end
