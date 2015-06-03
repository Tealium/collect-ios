//
//  TEALDispatchManager.h
//  TealiumUtilities
//
//  Created by George Webster on 1/19/15.
//  Copyright (c) 2015 Tealium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALDataQueue.h"

#import "TEALDispatchConstants.h"

@class TEALDispatchManager;

@protocol TEALDispatchManagerDelegate <NSObject>

- (void) dispatchManager:(TEALDispatchManager *)dataManager
        requestsDispatch:(TEALDispatch *)dispatch
         completionBlock:(TEALDispatchBlock)completionBlock;

- (BOOL) shouldAttemptDispatch;

- (NSUInteger) dispatchBatchSize;

- (NSUInteger) offlineDispatchQueueCapacity;

- (void) willEnqueueDispatch:(TEALDispatch *)dispatch;

- (void) didEnqueueDispatch:(TEALDispatch *)dispatch;

- (void) didUpdateDispatchQueues;

- (BOOL) hasDispatchExpired:(TEALDispatch *)dispatch;

- (void) willRunDispatchQueueWithCount:(NSUInteger)count;
- (void) didRunDispatchQueueWithCount:(NSUInteger)count;

@end

@interface TEALDispatchManager : NSObject

@property (strong, nonatomic, readonly) TEALDataQueue *sentDispatches;
@property (strong, nonatomic, readonly) TEALDataQueue *queuedDispatches;


+ (instancetype) managerWithDelegate:(id<TEALDispatchManagerDelegate>)delegate;

- (instancetype) initWithDelegate:(id<TEALDispatchManagerDelegate>)delegate;

- (void) updateQueuedCapacity:(NSUInteger)capacity;

#pragma mark - enqueue / dequeue dispatches

- (void) addDispatch:(TEALDispatch *)dispatch completionBlock:(TEALDispatchBlock)completionBlock;

- (void) purgeStaleDispatches;

- (void) runDispatchQueue;

- (void) disableDispatchQueue;

- (void) dequeueAllData;

- (NSUInteger) queuedDispatchCount;
- (NSUInteger) sentDispatchCount;

@end
