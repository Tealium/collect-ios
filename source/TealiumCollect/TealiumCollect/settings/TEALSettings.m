//
//  TEALSettings.m
//  Tealium Collect Library
//
//  Created by George Webster on 12/29/14.
//  Copyright (c) 2014 Tealium Inc. All rights reserved.
//

#import "TEALSettings.h"
#import "TEALSystemHelpers.h"
#import "TEALNetworkHelpers.h"
#import <TealiumUtilities/NSString+TealiumAdditions.h>
#import "TEALCollectConfiguration.h"

#import "TEALLogger.h"

@implementation TEALSettings

+ (instancetype) settingWithConfiguration:(TEALCollectConfiguration *)configuration
                                visitorID:(NSString *)visitorID {
    
    TEALSettings *setting = [[[self class] alloc] init];
    
    if (setting) {
        setting.account     = configuration.accountName;
        setting.tiqProfile  = configuration.profileName;
        setting.asProfile   = configuration.audienceStreamProfile;
        setting.environment = configuration.environmentName;
        setting.visitorID   = visitorID;
        
        setting.useHTTP             = configuration.useHTTP;
        setting.pollingFrequency    = configuration.pollingFrequency;
        setting.logLevel            = configuration.logLevel;
    }
    
    return setting;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        _status                         = TEALSettingsStatusNew;
        // Configuration
        _useHTTP                        = NO;
        _pollingFrequency               = TEALProfilePollingFrequencyAfterEveryEvent;
        // MPS
        _numberOfDaysDispatchesAreValid = -1;
        _dispatchSize                   = 1;
        _offlineDispatchQueueSize       = 1000; // -1 is supposed to be inf. but yeah thats alot
        _shouldLowBatterySuppress       = YES;
        _shouldSendWifiOnly             = NO;
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [self init];
    
    if (self) {
        _account                = [aDecoder decodeObjectForKey:@"account"];
        _tiqProfile             = [aDecoder decodeObjectForKey:@"tiqProfile"];
        _asProfile              = [aDecoder decodeObjectForKey:@"asProfile"];
        _environment            = [aDecoder decodeObjectForKey:@"environment"];
        _visitorID              = [aDecoder decodeObjectForKey:@"visitorID"];

        // Configuration
        _useHTTP                = [aDecoder decodeBoolForKey:@"useHTTP"];
        _pollingFrequency       = [aDecoder decodeIntegerForKey:@"pollingFrequency"];
        
        // MPS
        _mpsVersion                     = [aDecoder decodeObjectForKey:@"mpsVersion"];
        _numberOfDaysDispatchesAreValid = [aDecoder decodeIntegerForKey:@"numberOfDaysDispatchesAreValid"];
        _dispatchSize                   = [aDecoder decodeIntegerForKey:@"dispatchSize"];
        _offlineDispatchQueueSize       = [aDecoder decodeIntegerForKey:@"offlineDispatchQueueSize"];
        _shouldLowBatterySuppress       = [aDecoder decodeBoolForKey:@"shouldLowBatterySuppress"];
        _shouldSendWifiOnly             = [aDecoder decodeBoolForKey:@"shouldSendWifiOnly"];

        
        TEALSettingsStatus status = [aDecoder decodeIntegerForKey:@"status"];
        
        if (status == TEALSettingsStatusLoadedRemote) {
            status = TEALSettingsStatusLoadedArchive;
        }
        
        _status = status;
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.tiqProfile forKey:@"tiqProfile"];
    [aCoder encodeObject:self.asProfile forKey:@"asProfile"];
    [aCoder encodeObject:self.environment forKey:@"environment"];
    [aCoder encodeObject:self.visitorID forKey:@"visitorID"];
    
    [aCoder encodeInteger:self.status forKey:@"status"];
    
    // Configuration
    [aCoder encodeBool:self.useHTTP forKey:@"useHTTP"];
    [aCoder encodeInteger:self.pollingFrequency forKey:@"pollingFrequency"];
    
    // MPS
    [aCoder encodeObject:self.mpsVersion forKey:@"mpsVersion"];
    [aCoder encodeInteger:self.numberOfDaysDispatchesAreValid forKey:@"numberOfDaysDispatchesAreValid"];
    [aCoder encodeInteger:self.dispatchSize forKey:@"dispatchSize"];
    [aCoder encodeInteger:self.offlineDispatchQueueSize forKey:@""];
    [aCoder encodeBool:self.shouldLowBatterySuppress forKey:@"shouldLowBatterySuppress"];
    [aCoder encodeBool:self.shouldSendWifiOnly forKey:@"shouldSendWifiOnly"];
    
}


- (BOOL) isValid {
    return (self.account &&
            self.tiqProfile &&
            self.asProfile &&
            self.environment &&
            self.status != TEALSettingsStatusInvalid);
}

- (void) storeTraceID:(NSString *)traceID {
    
    self.traceID = traceID;
}

- (void) disableTrace {
    self.traceID = nil;
}

- (void) storeMobilePublishSettings:(NSDictionary *)rawSettings {
    

    self.mpsVersion = [TEALSystemHelpers mpsVersionNumber];
    
    if (!self.mpsVersion) {
        return;
    }
    
    if (![self isValid]) {
        return;
    }
    
    NSDictionary *settings = rawSettings[self.mpsVersion];

    TEAL_LogVerbose(@"storing settings: %@", settings);
    
    if (!settings) {
        return;
    }
    
    [self storeDispatchSizeFromSettings:settings];
    [self storeOfflineDispatchQueueSizeFromSettings:settings];
    [self storeDispatchExpirationFromSettings:settings];
    [self storeLowBatterySuppressionFromSettings:settings];
    [self storeWifiOnlySettingFromSettings:settings];
}

#pragma mark - Mobile Publish Settins

- (void) storeDispatchSizeFromSettings:(NSDictionary *)settings {

    NSString *batchSize = settings[@"event_batch_size"];
    
    if (batchSize) {
        self.dispatchSize = [batchSize integerValue];
    }
}

- (void) storeOfflineDispatchQueueSizeFromSettings:(NSDictionary *)settings {

    NSString *offlineSize = settings[@"offline_dispatch_limit"];
    
    if (offlineSize) {
        self.offlineDispatchQueueSize = [offlineSize integerValue];
    }
}

- (void) storeDispatchExpirationFromSettings:(NSDictionary *)settings {
    
    NSString *dispatchExpiration = settings[@"dispatch_expiration"];
    
    if (dispatchExpiration) {
        self.numberOfDaysDispatchesAreValid = [dispatchExpiration integerValue];
    }
}

- (void) storeLowBatterySuppressionFromSettings:(NSDictionary *)settings {
    
    NSString *lowBattery = settings[@"battery_saver"];
    
    if (lowBattery) {
        self.shouldLowBatterySuppress = [lowBattery boolValue];
    }
}

- (void) storeWifiOnlySettingFromSettings:(NSDictionary *)settings {
    
    NSString *wifiOnly = settings[@"wifi_only_sending"];
    
    if (wifiOnly) {
        self.shouldSendWifiOnly = [wifiOnly boolValue];
    }
}

- (NSString *) description {
    
    NSString *displayClass              = NSStringFromClass([self class]);
    NSString *displayHttp               = [NSString teal_stringFromBool:self.useHTTP];
    NSString *displayShouldWifiOnly     = [NSString teal_stringFromBool:self.shouldSendWifiOnly];
    NSString *displayShouldBatterySave  = [NSString teal_stringFromBool:self.shouldLowBatterySuppress];

    NSString *displayStatus             = nil;
    
    switch (self.status) {
        case TEALSettingsStatusNew:
            displayStatus = @"new";
            break;
        case TEALSettingsStatusLoadedRemote:
            displayStatus = @"remote";
            break;
        case TEALSettingsStatusLoadedArchive:
            displayStatus = @"archive";
            break;
        case TEALSettingsStatusInvalid:
            displayStatus = @"invalid";
            break;
    }
    return [NSString stringWithFormat:@"\r%@: \r account: %@ \r tiq profile: %@ \r as profile: %@ \r environment: %@ \r visitorID: %@ \r traceID: %@ \r status: %@ \r === Configuration === \r useHttp: %@ \r pollingFrequency: %lu \r logLevel: %d \r === MPS === \r mpsVersion: %@ \r dispatchSize: %ld \r offlineQueueSize: %ld \r numberOfDaysDispatchesAreValue: %ld \r shouldLowBatterySuppress: %@ \r shouldSendWifiOnly: %@ \r",
            displayClass,
            self.account,
            self.tiqProfile,
            self.asProfile,
            self.environment,
            self.visitorID,
            self.traceID,
            displayStatus,
            displayHttp,
            (unsigned long)self.pollingFrequency,
            2, // log level
            self.mpsVersion,
            (unsigned long)self.dispatchSize,
            (unsigned long)self.offlineDispatchQueueSize,
            (unsigned long)self.numberOfDaysDispatchesAreValid,
            displayShouldBatterySave,
            displayShouldWifiOnly];
}

@end
