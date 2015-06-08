//
//  TEALCollectDispatchManager.h
//  Tealium Collect Library
//
//  Created by George Webster on 2/17/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TealiumUtilities/TEALDispatchConstants.h>
#import "TEALSystemProtocols.h"
#import "TEALEvent.h"

@class TEALURLSessionManager;

@protocol TEALCollectDispatchManagerDelegate <NSObject>

- (BOOL) shouldAttemptDispatch;

@end

@protocol TEALCollectDispatchManagerConfiguration <NSObject, TEALURLSessions>

- (NSDictionary *) datasourcesForEventType:(TEALEventType)eventType;

- (NSString *) dispatchURLString;

- (NSUInteger) dispatchBatchSize;

- (NSUInteger) offlineDispatchQueueCapacity;

@end

@interface TEALCollectDispatchManager : NSObject

@property (weak, nonatomic) id<TEALCollectDispatchManagerDelegate> delegate;
@property (weak, nonatomic) id<TEALCollectDispatchManagerConfiguration> configuration;

+ (instancetype) dispatchManagerWithConfiguration:(id<TEALCollectDispatchManagerConfiguration>)configuration
                                         delegate:(id<TEALCollectDispatchManagerDelegate>)delegate;

- (instancetype) initWithConfiguration:(id<TEALCollectDispatchManagerConfiguration>)configuration
                              delegate:(id<TEALCollectDispatchManagerDelegate>)delegate;

- (void) addDispatchForEvent:(TEALEventType)eventType
                    withData:(NSDictionary *)userInfo
             completionBlock:(TEALDispatchBlock)completionBlock;

- (void) unarchiveDispatchQueue;
- (void) archiveDispatchQueue;

- (void) runQueuedDispatches;

@end
