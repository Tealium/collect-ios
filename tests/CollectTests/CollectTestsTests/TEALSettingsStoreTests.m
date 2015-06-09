//
//  TEALSettingsStoreTests.m
//  CollectTests
//
//  Created by George Webster on 6/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <TealiumCollect/TEALSettings.h>
#import <TealiumCollect/TEALSettingsStore.h>
#import <TealiumCollect/TEALOperationManager.h>
#import <TealiumCollect/TEALURLSessionManager.h>
#import <TealiumCollect/TEALCollectConfiguration.h>

@interface TEALSettingsStoreTests : XCTestCase <TEALSettingsStoreConfiguration>

@property (strong, nonatomic) TEALSettingsStore *settingsStore;
@property (strong, nonatomic) TEALOperationManager *operationManager;
@property (strong, nonatomic) TEALURLSessionManager *urlSessionManager;

@property (strong, nonatomic) TEALCollectConfiguration *configuration;

@end

@implementation TEALSettingsStoreTests

- (void)setUp {
    [super setUp];
    
    self.operationManager = [TEALOperationManager new];
    
    self.urlSessionManager = [[TEALURLSessionManager alloc] initWithConfiguration:nil];
    
    self.urlSessionManager.completionQueue = self.operationManager.underlyingQueue;
    
    self.settingsStore = [[TEALSettingsStore alloc] initWithConfiguration:self];
    
    self.configuration = [TEALCollectConfiguration configurationWithAccount:@"tealiummobile"
                                                                    profile:@"demo"
                                                                environment:@"dev"];
    
}

- (void)tearDown {
    
    self.operationManager = nil;
    self.urlSessionManager = nil;
    self.settingsStore = nil;
    
    self.configuration = nil;
    
    [super tearDown];
}


- (void) testConfigurationPollingFrequency {
    
    TEALVisitorProfilePollingFrequency targetFrequency = TEALVisitorProfilePollingFrequencyAfterEveryEvent;
    
    // default
    XCTAssertEqual(targetFrequency, self.configuration.pollingFrequency, @"TEALAudienceStreamConfiguration should default to %lu", (unsigned long)targetFrequency);
    
    targetFrequency = TEALVisitorProfilePollingFrequencyOnRequest;
    
    self.configuration.pollingFrequency = targetFrequency;
    
    TEALSettings *settings = [self.settingsStore settingsFromConfiguration:self.configuration visitorID:@""];
    
    
    XCTAssertEqual(targetFrequency, settings.pollingFrequency, @"Settigns Polling Frequency: %lu should be : %lu", (unsigned long)settings.pollingFrequency, (unsigned long)targetFrequency);
    
    
    targetFrequency = TEALVisitorProfilePollingFrequencyAfterEveryEvent;
    
    self.configuration.pollingFrequency = targetFrequency;
    
    settings = [self.settingsStore settingsFromConfiguration:self.configuration visitorID:@""];
    
    XCTAssertEqual(targetFrequency, settings.pollingFrequency, @"Settigns Polling Frequency: %lu should be : %lu", (unsigned long)settings.pollingFrequency, (unsigned long)targetFrequency);
    
}

- (void) testSettingsStorage {
    
    TEALSettings *startSettings = [self.settingsStore settingsFromConfiguration:self.configuration visitorID:@""];
    
    __block BOOL isReady = NO;
    
    [self.settingsStore fetchRemoteSettingsWithSetting:startSettings completion:^(TEALSettings *endSettings, NSError *error) {
        
        XCTAssertTrue([startSettings isEqual:endSettings], @"settings passed to completion should be same object passed in");
        
        isReady = YES;
    }];
    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !isReady){};
}

#pragma mark - TEALSettingsStoreConfiguration

- (NSString *) mobilePublishSettingsURLStringForSettings:(TEALSettings *)settings {
    return nil;
}

- (NSDictionary *) mobilePublishSettingsURLParams {
    return nil;
}

@end
