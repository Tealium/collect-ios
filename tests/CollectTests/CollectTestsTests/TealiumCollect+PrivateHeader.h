//
//  TealiumCollect+PrivateHeader.h
//  CollectTests
//
//  Created by George Webster on 6/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <TealiumCollect/TealiumCollect.h>
#import <TealiumCollect/TEALSettingsStore.h>
#import <TealiumCollect/TEALCollectDispatchManager.h>
#import <TealiumCollect/TEALURLSessionManager.h>
#import <TealiumCollect/TEALProfileStore.h>

@interface TealiumCollect (Private)

@property (strong, nonatomic) TEALSettingsStore *settingsStore;
@property (strong, nonatomic) TEALOperationManager *operationManager;
@property (strong, nonatomic) TEALProfileStore *profileStore;
@property (strong, nonatomic) TEALCollectDispatchManager *dispatchManager;
@property (strong, nonatomic) TEALURLSessionManager *urlSessionManager;

@property (nonatomic) BOOL enabled;

- (instancetype) initPrivate;

- (void) setupConfiguration:(TEALCollectConfiguration *)configuration
                 completion:(TEALBooleanCompletionBlock)setupCompletion;

- (void) fetchSettings:(TEALSettings *)settings
            completion:(TEALBooleanCompletionBlock)setupCompletion;

- (void) enable;

- (void) joinTraceWithToken:(NSString *)token;
- (void) leaveTrace;

@end

