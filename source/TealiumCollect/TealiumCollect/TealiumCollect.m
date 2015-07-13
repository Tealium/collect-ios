//
//  Tealium Collect Library.m
//  Tealium Collect Library
//
//  Created by George Webster on 1/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TealiumCollect.h"

#import "TEALSettingsStore.h"
#import "TEALCollectDispatchManager.h"

//#import "TEALDatasourceManager.h"

#import "TEALVisitorProfileStore.h"
#import "TEALSettings.h"

// Queue / Operation Managers

#import "TEALOperationManager.h"
#import "TEALCollectDispatchManager.h"

// Networking

#import "TEALURLSessionManager.h"
#import "TEALNetworkHelpers.h"

// Dispatch

#import <TealiumUtilities/TEALDispatch.h>

// Logging

#import "TEALLogger.h"

// Datasources

#import "TEALCollectDatasources.h"
#import <TealiumUtilities/TEALDataSourceStore.h>
#import "TEALDatasourceStore+TealiumCollectAdditions.h"

// Profile

#import "TEALVisitorProfileHelpers.h"

// API

#import "TEALCollectAPIHelpers.h"

@interface TealiumCollect () <TEALSettingsStoreConfiguration, TEALCollectDispatchManagerDelegate, TEALCollectDispatchManagerConfiguration, TEALVisitorProfileStoreConfiguration>

@property (strong, nonatomic) TEALSettingsStore *settingsStore;
@property (strong, nonatomic) TEALCollectDispatchManager *dispatchManager;
@property (strong, nonatomic) TEALVisitorProfileStore *profileStore;

@property (strong, nonatomic) TEALDatasourceStore *datasourceStore;

@property (strong, nonatomic) TEALOperationManager *operationManager;

@property (strong, nonatomic) TEALURLSessionManager *urlSessionManager;

@property (copy, readwrite) NSString *visitorID;
@property (copy, readwrite) TEALVisitorProfile *cachedProfile;
@property (readwrite) BOOL enabled;



@end

@implementation TealiumCollect

+ (instancetype) sharedInstance {
    
    static dispatch_once_t onceToken = 0;
    __strong static TealiumCollect *_sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[TealiumCollect alloc] initPrivate];
    });
    
    return _sharedObject;
}

- (instancetype) init {
    [NSException raise:@"should not be initialized directly"
                format:@"please use [TealiumCollect sharedInstance] or public class methods"];
    return nil;
}

- (instancetype) initPrivate {
    
    self = [super init];
    
    if (self) {
        _operationManager   = [TEALOperationManager new];
        _urlSessionManager  = [[TEALURLSessionManager alloc] initWithConfiguration:nil];
        
        _urlSessionManager.completionQueue = _operationManager.underlyingQueue;
        
        _settingsStore      = [[TEALSettingsStore alloc] initWithConfiguration:self];
        
        [_settingsStore unarchiveCurrentSettings];
        
        _dispatchManager    = [TEALCollectDispatchManager dispatchManagerWithConfiguration:self
                                                                                  delegate:self];
    }
    
    return self;
}

#pragma mark - Enable / Disable / Configure settings / startup

+ (void) enableWithConfiguration:(TEALCollectConfiguration *)configuration {
    
    [[self class] enableWithConfiguration:configuration
                               completion:nil];
}

+ (void) enableWithConfiguration:(TEALCollectConfiguration *)configuration
                      completion:(TEALBooleanCompletionBlock)completion {
    
    __weak TealiumCollect *instance = [[self class] sharedInstance];
    
    [instance.operationManager addOperationWithBlock:^{
        
        [instance setupConfiguration:configuration completion:completion];
        
    }];
    
    [instance enable];
}

- (void) setupConfiguration:(TEALCollectConfiguration *)configuration
                 completion:(TEALBooleanCompletionBlock)setupCompletion {
    
    
    self.datasourceStore = [TEALDatasourceStore sharedStore];
    [self.datasourceStore loadWithUUIDKey:configuration.accountName];
    
    NSString *accountUUID = self.datasourceStore[TEALDatasourceKey_UUID];
    
    NSString *visitorID = [accountUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    self.visitorID = visitorID;
    
    self.profileStore = [[TEALVisitorProfileStore alloc] initWithConfiguration:self];  // needs valid visitorID

    TEALSettings *settings = [self.settingsStore settingsFromConfiguration:configuration visitorID:visitorID];
    
    [TEALLogger setLogLevel:settings.logLevel];
    
    [self fetchSettings:settings
             completion:setupCompletion];
    
    [self setupSettingsReachabilitiyCallbacks];
}

- (void) fetchSettings:(TEALSettings *)settings
            completion:(TEALBooleanCompletionBlock)setupCompletion {
    
    __weak TealiumCollect *weakSelf = self;
    
    TEALSettingsCompletionBlock settingsCompletion = ^(TEALSettings *settings, NSError *error) {
        
        BOOL settingsSuccess = NO;
        
        if (settings) {
            TEAL_LogVerbose(@"Retrieved settings: %@", settings);
            
            if (settings.status == TEALSettingsStatusLoadedRemote) {
                settingsSuccess = YES;
            }
            
            [weakSelf updateStateForSettingsStatus:settings.status];
        }
        
        if (error) {
            TEAL_LogVerbose(@"Problems while fetching settings: %@ \r error:%@", settings, [error localizedDescription]);
            settingsSuccess = NO;
        }
        
        [weakSelf.operationManager addOperationWithBlock:^{
            
            [weakSelf.settingsStore archiveCurrentSettings];
        }];
        
        if (setupCompletion) {
            setupCompletion(settingsSuccess, error);
        }
        
        if (settingsSuccess) {
            [weakSelf.dispatchManager runQueuedDispatches];
        } else {
            [weakSelf disable];
        }
    };
    
    [self.settingsStore fetchRemoteSettingsWithSetting:settings
                                            completion:settingsCompletion];
    
    
    [self.dispatchManager unarchiveDispatchQueue];
}

- (void) updateStateForSettingsStatus:(TEALSettingsStatus)status {
    
    switch (status) {
        case TEALSettingsStatusNew:
        case TEALSettingsStatusLoadedArchive:
        case TEALSettingsStatusLoadedRemote:
            
            break;
        case TEALSettingsStatusInvalid:
            TEAL_LogVerbose(@"Invalid Settings library is shutting now.  Please enable with valid configuration.");
            [TealiumCollect disable];
            break;
    }
}

- (void) setupSettingsReachabilitiyCallbacks {
    
    if (self.urlSessionManager.reachability.reachableBlock) {
        return;
    }
    
    __weak TealiumCollect *weakSelf = self;
    __weak TEALSettings *settings = weakSelf.settingsStore.currentSettings;
    
    weakSelf.urlSessionManager.reachability.reachableBlock = ^(TEALReachabilityManager *reachability) {
        
        [weakSelf fetchSettings:settings
                     completion:nil];
    };
}


#pragma mark - TEALSettingsStoreConfiguration methods

- (NSString *) mobilePublishSettingsURLStringForSettings:(TEALSettings *)settings {
    
    if (!settings) {
        return nil;
    }
    
    return [TEALCollectAPIHelpers mobilePublishSettingsURLStringFromSettings:settings];
}

- (NSDictionary *) mobilePublishSettingsURLParams {
    return [self.datasourceStore systemInfoDatasources];
}


#pragma mark - Enable/Disable

+ (void) disable {
    [[self sharedInstance] disable];
}

- (void) disable {
    @synchronized(self) {
        
        self.enabled = NO;
    }
}

- (void) enable {
    
    @synchronized(self) {
        
        self.enabled = YES;
    }
}

#pragma mark - Tracking / Send Data

+ (void) sendEventWithData:(NSDictionary *)customData {
    
    __weak TealiumCollect *instance = [[self class] sharedInstance];
    
    if (!instance.enabled) {
        TEAL_LogVerbose(@"AudienceStream Library Disabled, Ignoring: %s", __PRETTY_FUNCTION__);
        return;
    }
    
    [instance.operationManager addOperationWithBlock:^{
        
        [instance sendEvent:TEALEventTypeLink
                   withData:customData];
    }];
}

+ (void) sendViewWithData:(NSDictionary *)customData {
    
    __weak TealiumCollect *instance = [[self class] sharedInstance];
    
    if (!instance.enabled) {
        TEAL_LogVerbose(@"AudienceStream Library Disabled, Ignoring: %s", __PRETTY_FUNCTION__);
        return;
    }
    
    [instance.operationManager addOperationWithBlock:^{
        
        [instance sendEvent:TEALEventTypeView
                   withData:customData];
    }];
}

- (void) sendEvent:(TEALEventType)eventType withData:(NSDictionary *)customData {
    
    __weak TealiumCollect *weakSelf = self;
    
    TEALDispatchBlock completion = ^(TEALDispatchStatus status, TEALDispatch *dispatch, NSError *error) {
        
        switch (status) {
            case TEALDispatchStatusSent:
            case TEALDispatchStatusQueued:
                
                [weakSelf dispatchManager:weakSelf.dispatchManager
                       didProcessDispatch:dispatch
                                   status:status];
                
                break;
            case TEALDispatchStatusFailed:
            case TEALDispatchStatusUnknown:
                
                TEAL_LogVerbose(@"error: %@", [error localizedDescription]);
                break;
        }
    };
    
    [self.dispatchManager addDispatchForEvent:eventType
                                     withData:customData
                              completionBlock:completion];
    
    [self.dispatchManager archiveDispatchQueue];
}

- (void) dispatchManager:(TEALCollectDispatchManager *)dispatchManager didProcessDispatch:(TEALDispatch *)dispatch status:(TEALDispatchStatus)status {
    
    if (self.settingsStore.currentSettings.logLevel >= TEALCollectLogLevelVerbose) {
        
        NSString *statusString = @"sent";
        
        if  (status == TEALDispatchStatusQueued) {
            statusString = @"queued";
        }
        
        if ([dispatch.payload isKindOfClass:[NSString class]]) {
            NSDictionary *datalayerDump = [TEALNetworkHelpers dictionaryFromUrlParamString:(NSString *)dispatch.payload];
            
            TEAL_LogVerbose(@"Successfully %@ dispatch with payload %@", statusString, datalayerDump);
            
        } else {
            
            TEAL_LogVerbose(@"Successfully %@ dispatch.", statusString)
        }
    }
    if (self.settingsStore.currentSettings.pollingFrequency == TEALVisitorProfilePollingFrequencyOnRequest) {
        return;
    }
    
    [self fetchProfileWithCompletion:^(TEALVisitorProfile *profile, NSError *error) {
        
        TEAL_LogVerbose(@"did fetch profile: %@ after dispatch event", profile);
    }];
}

#pragma mark - TEALCollectDispatchManagerDelegate methods

- (BOOL) shouldAttemptDispatch {
    
    TEALSettings *settings = self.settingsStore.currentSettings;
    
    BOOL shouldAttempt = ( [settings isValid] && settings.status != TEALSettingsStatusNew );
    
    if (shouldAttempt) {
        shouldAttempt = [self.urlSessionManager.reachability isReachable];
    }
    
    return shouldAttempt;
}

#pragma mark - TEALCollectDispatchManagerConfiguration methods

- (NSDictionary *) datasourcesForEventType:(TEALEventType)eventType {
    return [self.datasourceStore datasourcesForEventType:eventType];
}

- (NSString *) dispatchURLString {
    
    TEALSettings *settings = self.settingsStore.currentSettings;
    
    return [TEALCollectAPIHelpers sendDataURLStringFromSettings:settings];
}

- (NSUInteger) dispatchBatchSize {
    
    TEALSettings *settings = self.settingsStore.currentSettings;
    
    return [settings dispatchSize];
}

- (NSUInteger) offlineDispatchQueueCapacity {
    
    TEALSettings *settings = self.settingsStore.currentSettings;
    
    return [settings offlineDispatchQueueSize];
}

#pragma mark - Profile

+ (void) fetchVisitorProfileWithCompletion:(void (^)(TEALVisitorProfile *profile, NSError *error))completion {
    
    __weak TealiumCollect *instance = [[self class] sharedInstance];
    
    if (!instance.enabled) {
        TEAL_LogVerbose(@"AudienceStream Library Disabled, Ignoring: %s", __func__);
        return;
    }
    
    [instance.operationManager addOperationWithBlock:^{
        
        [instance fetchProfileWithCompletion:completion];
    }];
}

- (void) fetchProfileWithCompletion:(void (^)(TEALVisitorProfile *profile, NSError *error))completion {
    
    __weak TealiumCollect *weakSelf = self;
    
    if (!self.enabled) {
        return; // No fail log because these they should be logged once for each public method
    }
    
    
    TEALVisitorProfileCompletionBlock storeCompletion = ^(TEALVisitorProfile *profile, NSError *error) {
        
        if (profile) {
            TEAL_LogVerbose(@"got profile!!! : %@", profile);
            
            weakSelf.cachedProfile = profile;
            
            completion(weakSelf.cachedProfile, nil);
            
        } else {
            TEAL_LogVerbose(@"problem fetching profile: %@", [error localizedDescription]);
        }
    };
    [self.profileStore fetchProfileWithCompletion:storeCompletion];
}

+ (TEALVisitorProfile *) cachedVisitorProfileCopy {
    
    TealiumCollect *instance = [self sharedInstance];
    
    @synchronized(instance) {
        
        return instance.cachedProfile;
    }
}

#pragma mark - TEALVisitorProfileStoreConfiguration

- (NSURL *) profileURL {
    
    TEALSettings *settings = self.settingsStore.currentSettings;

    return [TEALCollectAPIHelpers profileURLFromSettings:settings];
}

- (NSURL *) profileDefinitionURL {
    
    TEALSettings *settings = self.settingsStore.currentSettings;
    
    return [TEALCollectAPIHelpers profileDefinitionsURLFromSettings:settings];
}

#pragma mark - Visitor ID

+ (NSString *) visitorID {
    
    TealiumCollect *instance = [self sharedInstance];
    
    @synchronized(instance) {
        
        return instance.visitorID;
    }
}


#pragma mark - Trace

+ (void) joinTraceWithToken:(NSString *)token {
    
    __weak TealiumCollect *instance = [[self class] sharedInstance];
    
    [instance.operationManager addOperationWithBlock:^{
        [instance joinTraceWithToken:token];
    }];
}

- (void) joinTraceWithToken:(NSString *)token {
    
    if (!self.enabled) {
        TEAL_LogVerbose(@"AudienceStream Library Disabled, Ignoring: %s", __func__);
        return;
    }
    
    if (!token || ![token length]) {
        return;
    }
    
    [self.settingsStore.currentSettings storeTraceID:token];
}

+ (void) leaveTrace {
    
    __weak TealiumCollect *instance = [[self class] sharedInstance];
    
    [instance.operationManager addOperationWithBlock:^{
        [instance leaveTrace];
    }];
}

- (void) leaveTrace {
    
    if (!self.enabled) {
        TEAL_LogVerbose(@"AudienceStream Library Disabled, Ignoring: %s", __func__);
        return;
    }
    
    [self.settingsStore.currentSettings disableTrace];
}


@end
