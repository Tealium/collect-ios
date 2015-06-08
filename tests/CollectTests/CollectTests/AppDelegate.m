//
//  AppDelegate.m
//  CollectTests
//
//  Created by George Webster on 6/3/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "AppDelegate.h"

#import <TealiumCollect/TealiumCollect.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    TEALCollectConfiguration *config = [TEALCollectConfiguration configurationWithAccount:@"tealiummobile"
                                                                                  profile:@"demo"
                                                                              environment:@"dev"];
    
    config.logLevel = TEALCollectLogLevelExtremeVerbosity;
    config.pollingFrequency = TEALProfilePollingFrequencyOnRequest;
    
    [TealiumCollect enableWithConfiguration:config];
    
    return YES;
}

@end
