//
//  TEALAudienceStreamDispatchManager.h
//  TEALAudienceStream
//
//  Created by George Webster on 2/17/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TealiumUtilities/TEALDispatchConstants.h>
#import "TEALSystemProtocols.h"
#import "TEALEvent.h"

@class TEALURLSessionManager;

@protocol TEALAudienceStreamDispatchManagerDelegate <NSObject>

- (BOOL) shouldAttemptDispatch;

@end

@protocol TEALAudienceStreamDispatchManagerConfiguration <NSObject, TEALURLSessions>

- (NSDictionary *) datasourcesForEventType:(TEALEventType)eventType;

- (NSString *) dispatchURLString;

- (NSUInteger) dispatchBatchSize;

- (NSUInteger) offlineDispatchQueueCapacity;

@end

@interface TEALAudienceStreamDispatchManager : NSObject

@property (weak, nonatomic) id<TEALAudienceStreamDispatchManagerDelegate> delegate;
@property (weak, nonatomic) id<TEALAudienceStreamDispatchManagerConfiguration> configuration;

+ (instancetype) dispatchManagerWithConfiguration:(id<TEALAudienceStreamDispatchManagerConfiguration>)configuration
                                         delegate:(id<TEALAudienceStreamDispatchManagerDelegate>)delegate;

- (instancetype) initWithConfiguration:(id<TEALAudienceStreamDispatchManagerConfiguration>)configuration
                              delegate:(id<TEALAudienceStreamDispatchManagerDelegate>)delegate;

- (void) addDispatchForEvent:(TEALEventType)eventType
                    withData:(NSDictionary *)userInfo
             completionBlock:(TEALDispatchBlock)completionBlock;

- (void) unarchiveDispatchQueue;
- (void) archiveDispatchQueue;

- (void) runQueuedDispatches;

@end
