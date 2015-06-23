//
//  AppDelegate.m
//  CollectAPISampler
//
//  Created by George Webster on 6/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "AppDelegate.h"

#import <TealiumCollect/TealiumCollect.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    TEALCollectConfiguration *config = [TEALCollectConfiguration configurationWithAccount:@"tealiummobile"
                                                                                  profile:@"demo"
                                                                              environment:@"dev"];
    
    config.logLevel = TEALCollectLogLevelExtremeVerbosity;

    // If you only want profile enrichment on request.
    // By default the visitor profile is polled each Send Event/View.
    //config.pollingFrequency = TEALProfilePollingFrequencyOnRequest;
    
    [TealiumCollect enableWithConfiguration:config];
    
    [self sendLifecycleEventWithName:@"mobile_launch"];
    
    return YES;
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
    
    [self sendLifecycleEventWithName:@"mobile_sleep"];
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
    
    [self sendLifecycleEventWithName:@"mobile_wake"];
}

- (void) sendLifecycleEventWithName:(NSString *)name {

    NSDictionary *data = @{ @"event_name" : name };
    
    [TealiumCollect sendEventWithData:data];
}

@end
