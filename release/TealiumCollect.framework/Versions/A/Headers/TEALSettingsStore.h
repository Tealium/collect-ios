//
//  TEALSettingsStore.h
//  AudienceStream Library
//
//  Created by George Webster on 12/29/14.
//  Copyright (c) 2014 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALSystemProtocols.h"

@class TEALSettings;
@class TEALURLSessionManager;
@class TEALCollectConfiguration;
@class TEALOperationManager;


typedef void (^TEALSettingsCompletionBlock)(TEALSettings *settings, NSError *error);

@protocol TEALSettingsStoreConfiguration <NSObject, TEALOperations, TEALURLSessions>

- (NSString *) mobilePublishSettingsURLStringForSettings:(TEALSettings *)settings;
- (NSDictionary *) mobilePublishSettingsURLParams;

@end

@interface TEALSettingsStore : NSObject

@property (readonly, nonatomic) TEALSettings *currentSettings;
@property (weak, nonatomic) id<TEALSettingsStoreConfiguration> configuration;

- (instancetype) initWithConfiguration:(id<TEALSettingsStoreConfiguration>)configuration;

- (TEALSettings *) settingsFromConfiguration:(TEALCollectConfiguration *)configuration visitorID:(NSString *)visitorID;

- (void) unarchiveCurrentSettings;
- (void) archiveCurrentSettings;

- (void) fetchRemoteSettingsWithSetting:(TEALSettings *)settings
                             completion:(TEALSettingsCompletionBlock)completion;


@end
