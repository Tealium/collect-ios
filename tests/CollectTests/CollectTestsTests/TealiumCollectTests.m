//
//  TealiumCollectTests.m
//  CollectTests
//
//  Created by George Webster on 6/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <TealiumCollect/TealiumCollect.h>
#import <TealiumCollect/TEALSettings.h>
#import "TealiumCollect+PrivateHeader.h"


@interface TealiumCollectTests : XCTestCase

@property (strong) TealiumCollect *collectLibrary;
@property TEALCollectConfiguration *configuration;

@end

@implementation TealiumCollectTests

- (void) setUp {
    [super setUp];
    
    self.collectLibrary = [[TealiumCollect alloc] initPrivate];
    
    self.configuration = [TEALCollectConfiguration configurationWithAccount:@"tealiummobile"
                                                                    profile:@"demo"
                                                                environment:@"dev"];
}

- (void) tearDown {
    
    [TealiumCollect disable];
    self.collectLibrary = nil;
    
    [super tearDown];
}

#pragma mark - Helpers

- (void) enableLibraryWithConfiguration:(TEALCollectConfiguration *)config {
    
    if (!config) {
        config = self.configuration;
    }

    __block BOOL isReady = NO;
    
    [self.collectLibrary setupConfiguration:config
                                 completion:^(BOOL success, NSError *error) {
                                     isReady = YES;
                                 }];
    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !isReady){}
}

- (void) fetchRemoteSettingsWithSettings:(TEALSettings *)settings {
    
    self.collectLibrary.enabled = YES;
    
    __block BOOL isReady = NO;
    
    [self.collectLibrary fetchSettings:settings completion:^(BOOL success, NSError *error) {
        
        isReady = YES;
    }];
    
    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !isReady){};
}

#pragma mark - Test Configuration / Settings updates

- (void) testSettingsStorage {
    
    [self enableLibraryWithConfiguration:nil];
    
    TEALSettings *settings = [self.collectLibrary.settingsStore settingsFromConfiguration:self.configuration
                                                                                visitorID:@""];
    
    [self fetchRemoteSettingsWithSettings:settings];
    
    XCTAssertTrue([self.collectLibrary.settingsStore.currentSettings isEqual:settings], @"saved settings should be same object passed in");
}

- (void) testInvalidAccount {
    
    TEALCollectConfiguration *config = [TEALCollectConfiguration configurationWithAccount:@"invalid_tealiummobile"
                                                                                  profile:@"demo"
                                                                              environment:@"dev"];
    
    [self enableLibraryWithConfiguration:config];
    
    TEALSettings *settings = [self.collectLibrary.settingsStore settingsFromConfiguration:config visitorID:@""];
    
    [self fetchRemoteSettingsWithSettings:settings];
    
    XCTAssertTrue(self.collectLibrary.settingsStore.currentSettings.status == TEALSettingsStatusInvalid, @"Stored status should be invalid");
    
    XCTAssertFalse(self.collectLibrary.enabled, @"Library should be disabled on invalid settings status");
}

- (void) testNoMobilePublishSettings {

    TEALCollectConfiguration *config = [TEALCollectConfiguration configurationWithAccount:@"tealiummobile"
                                                                                  profile:@"ios-demo"
                                                                            environment:@"dev"];

    [self enableLibraryWithConfiguration:config];

    TEALSettings *settings = [self.collectLibrary.settingsStore settingsFromConfiguration:config visitorID:@""];
    
    [self fetchRemoteSettingsWithSettings:settings];
    
    XCTAssertTrue(self.collectLibrary.settingsStore.currentSettings.status == TEALSettingsStatusInvalid, @"Stored status should be invalid");
    
    XCTAssertFalse(self.collectLibrary.enabled, @"Library should be disabled on invalid settings status");
}

#pragma mark - Trace

- (void) testTrace {
    
    [self enableLibraryWithConfiguration:nil];

    TEALSettings *settings = [self.collectLibrary.settingsStore settingsFromConfiguration:self.configuration visitorID:@""];
    
    [self fetchRemoteSettingsWithSettings:settings];
    
    NSString *token = @"A1B2C3";
    
    settings = self.collectLibrary.settingsStore.currentSettings;
    
    XCTAssertTrue(settings.traceID == nil, @"TraceID datasource should default to nil");
    
    [self.collectLibrary joinTraceWithToken:token];
    
    XCTAssertTrue(settings.traceID != nil, @"TraceID datasource:%@ now have a value.", settings.traceID);
    
    XCTAssertTrue([settings.traceID isEqualToString:token], @"TraceID datasource value: %@ should be same as token passed in: %@", settings.traceID, token);
    
    [self.collectLibrary leaveTrace];
    
    XCTAssertTrue(settings.traceID == nil, @"TraceID datasource :%@ should now be nil", settings.traceID);
    
}


#pragma mark - Dispatch

- (void) testDispatch {
    
    [self enableLibraryWithConfiguration:nil];

    TEALSettings *settings = [self.collectLibrary.settingsStore settingsFromConfiguration:self.configuration visitorID:@""];
    
    [self fetchRemoteSettingsWithSettings:settings];
    
    TEALDispatchBlock completion = ^(TEALDispatchStatus status, TEALDispatch *dispatch, NSError *error) {
        
        XCTAssertEqual(status, TEALDispatchStatusSent, @"Dispatch: %@, should have been sent", dispatch);
    };
    
    [self.collectLibrary.dispatchManager addDispatchForEvent:TEALEventTypeLink
                                                    withData:@{@"test_key":@"test_value"}
                                             completionBlock:completion];
    
    self.collectLibrary.settingsStore.currentSettings.dispatchSize = 5;
    
    completion = ^(TEALDispatchStatus status, TEALDispatch *dispatch, NSError *error) {
        
        XCTAssertEqual(status, TEALDispatchStatusQueued, @"Dispatch: %@, should have been queued", dispatch);
    };
    
    for (NSInteger xi = 0; xi < 5; xi ++) {
        [self.collectLibrary.dispatchManager addDispatchForEvent:TEALEventTypeLink
                                                        withData:@{@"test_key":@"test_value"}
                                                 completionBlock:completion];
    }
}



@end
