//
//  TEALDatasourceStore+TEALAudienceStreamAdditions.m
//  ASTester
//
//  Created by George Webster on 4/15/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALDatasourceStore+TEALAudienceStreamAdditions.h"

#import <UIKit/UIDevice.h>
#import "TEALSystemHelpers.h"
#import "TEALNetworkHelpers.h"
#import <TealiumUtilities/NSDate+TealiumAdditions.h>
#import <TealiumUtilities/NSString+TealiumAdditions.h>

static NSString * const kTEALAudienceStreamDatasourceStorageKey = @"com.tealium.audiencestream.datasources";


@implementation TEALDatasourceStore (TEALAudienceStreamAdditions)

- (void) loadWithUUIDKey:(NSString *)key {
    
    NSString *storagekey = [kTEALAudienceStreamDatasourceStorageKey copy];
    if (![self unarchiveWithStorageKey:storagekey]) {
        
        [self addDefaultDatasources];
    }
    
    [TEALDatasourceStore sharedStore][TEALDatasourceKey_UUID] = [TEALSystemHelpers applicationUUIDWithKey:key];
    
    [self archiveWithStorageKey:kTEALAudienceStreamDatasourceStorageKey];
}


- (void) addDefaultDatasources {
    
    self[TEALDatasourceKey_EventName]          = @"mobile_link";
    self[TEALDatasourceKey_Pagetype]           = @"mobile_view";
    self[TEALDatasourceKey_Platform]           = @"iOS";
    self[TEALDatasourceKey_SystemVersion]      = [[UIDevice currentDevice] systemVersion];
    self[TEALDatasourceKey_LibraryVersion]     = [TEALSystemHelpers audienceStreamLibraryVersion];
    self[TEALDatasourceKey_ApplicationName]    = [TEALSystemHelpers applicationName];
}

- (NSDictionary *) systemInfoDatasources {

    NSMutableDictionary *datasources = [self datasourcesForKeys:@[TEALDatasourceKey_Platform,
                                                                  TEALDatasourceKey_SystemVersion,
                                                                  TEALDatasourceKey_LibraryVersion]];
    
    datasources[TEALDatasourceKey_Timestamp] = [[NSDate date] teal_timestampISOStringValue];

    return datasources;
}

- (NSMutableDictionary *) datasourcesForKeys:(NSArray *)keys {
    
    NSMutableDictionary *datasources = [NSMutableDictionary new];

    for (id key in keys) {
        
        id obj = self[key];

        if (obj) {
            datasources[key] = obj;
        }
    }
    return datasources;
}

- (NSDictionary *) datasourcesForEventType:(TEALEventType)eventType {
    
    NSMutableDictionary *datasources = [NSMutableDictionary new];

    NSDictionary *systemInfo = [self systemInfoDatasources];
    
    [datasources addEntriesFromDictionary:systemInfo];
    
    datasources[TEALDatasourceKey_CallType]         = [TEALNetworkHelpers eventStringFromType:eventType];
    datasources[TEALDatasourceKey_ApplicationName]  = self[TEALDatasourceKey_ApplicationName];

    switch (eventType) {
        case TEALEventTypeLink:
            datasources[TEALDatasourceKey_EventName] = self[TEALDatasourceKey_EventName];
            break;
        case TEALEventTypeView:
            datasources[TEALDatasourceKey_Pagetype] = self[TEALDatasourceKey_Pagetype];
            break;
        default:
            break;
    }
    
    return datasources;
}

- (NSDictionary *) queuedFlagWithValue:(BOOL)value {
    
    NSString *displayString = [NSString teal_stringFromBool:value];
    
    return @{ @"was_queued" : displayString };
}

@end
