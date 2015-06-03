//
//  TEALAudienceStreamDispatchManager.m
//  AudienceStream Library
//
//  Created by George Webster on 2/17/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALAudienceStreamDispatchManager.h"

#import "TEALNetworkHelpers.h"
#import "TEALURLSessionManager.h"

#import <TealiumUtilities/TEALDispatchConstants.h>
#import <TealiumUtilities/TEALDispatch.h>
#import <TealiumUtilities/TEALDispatchManager.h>

#import <TealiumUtilities/TEALBlocks.h>

#import "TEALLogger.h"


static NSString * const AudienceStream_DispatchQueueKey = @"com.tealium.audience_stream.dispatch_queue";
static NSString * const AudienceStream_IOQueueKey = @"com.tealium.audience_stream.io_queue";

@interface TEALAudienceStreamDispatchManager () <TEALDispatchManagerDelegate>

@property (strong, nonatomic) TEALDispatchManager *dispatchManager;

@property (strong, nonatomic) dispatch_queue_t ioQueue;

@end

@implementation TEALAudienceStreamDispatchManager

+ (instancetype) dispatchManagerWithConfiguration:(id<TEALAudienceStreamDispatchManagerConfiguration>)configuration
                                         delegate:(id<TEALAudienceStreamDispatchManagerDelegate>)delegate {
    
    return [[TEALAudienceStreamDispatchManager alloc] initWithConfiguration:configuration
                                                                   delegate:delegate];
}

- (instancetype) initWithConfiguration:(id<TEALAudienceStreamDispatchManagerConfiguration>)configuration
                              delegate:(id<TEALAudienceStreamDispatchManagerDelegate>)delegate {

    self = [self init];
    
    if (self) {
        _configuration      = configuration;
        _delegate           = delegate;
        _dispatchManager    = [TEALDispatchManager managerWithDelegate:self];
        _ioQueue            = dispatch_queue_create([AudienceStream_IOQueueKey cStringUsingEncoding:NSUTF8StringEncoding],
                                                    DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (TEALDispatch *) dispatchForEvent:(TEALEventType)eventType withData:(NSDictionary *)userInfo {

    NSDictionary *datasources = [self.configuration datasourcesForEventType:eventType];

    if (userInfo) {
        
        NSMutableDictionary *combined = [NSMutableDictionary dictionaryWithDictionary:datasources];
        
        [combined addEntriesFromDictionary:userInfo];
        datasources = combined;
    }

    NSString *datasourcePayload = [TEALNetworkHelpers urlParamStringFromDictionary:datasources];
    
    NSString *userPayload = [TEALNetworkHelpers urlParamStringFromDictionary:userInfo];

    NSString *payload = [datasourcePayload stringByAppendingFormat:@"&%@", userPayload];
    
    TEALDispatch *dispatch = [TEALDispatch new];
    
    dispatch.payload    = payload;
    dispatch.timestamp  = [[NSDate date] timeIntervalSince1970];
    
    return dispatch;
}

- (void) addDispatchForEvent:(TEALEventType)eventType
                    withData:(NSDictionary *)userInfo
             completionBlock:(TEALDispatchBlock)completionBlock {
    
    TEALDispatch *dispatch = [self dispatchForEvent:eventType withData:userInfo];
    
    TEALDispatchBlock dispatchCompletion = ^(TEALDispatchStatus status, TEALDispatch *dispatch, NSError *error) {
        
        completionBlock(status, dispatch, error);
    };
    
    [self.dispatchManager addDispatch:dispatch
                      completionBlock:dispatchCompletion];
}

- (void) runQueuedDispatches {
    
    [self.dispatchManager runDispatchQueue];
}

#pragma mark - Network

- (void) sendDisptach:(TEALDispatch *)dispatch
                queue:(dispatch_queue_t)callBackQueue
       withCompletion:(TEALBooleanCompletionBlock)completion {
    
    if (!self.delegate) {
        NSError *error = nil; // TODO: make error helper
        completion( NO, error);
        
        return;
    }
    
    NSString *baseURLString = [self.configuration dispatchURLString];
    
    NSError *error = nil;
    
    NSString *urlString = [baseURLString stringByAppendingFormat:@"&%@", dispatch.payload];
    
    
    if (!urlString) {
        completion(NO, error);
        return;
    }
    
    NSURLRequest *request = [TEALNetworkHelpers requestWithURLString:urlString];
    
    if (!request) {
        completion( NO, nil );
        return;
    }
    
    TEALHTTPResponseBlock requestCompletion = ^(NSHTTPURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (completion) {
            
            BOOL success = (!connectionError);
            
            completion( success, connectionError );
        }
    };
    
    [[self.configuration urlSessionManager] performRequest:request
                                            withCompletion:requestCompletion];
}


#pragma mark - TEALDispatchManagerDelegate

- (void) dispatchManager:(TEALDispatchManager *)dataManager
        requestsDispatch:(TEALDispatch *)dispatch
         completionBlock:(TEALDispatchBlock)completionBlock {

    dispatch_queue_t queue = nil;
    
    [self sendDisptach:dispatch
                 queue:queue
        withCompletion:^(BOOL success, NSError *error) {
            
            TEALDispatchStatus status = (success) ? TEALDispatchStatusSent : TEALDispatchStatusFailed;

            completionBlock(status, dispatch, error);
            
        }];
}

- (BOOL) shouldAttemptDispatch {

    return [self.delegate shouldAttemptDispatch];
}

- (NSUInteger) dispatchBatchSize {

    return [self.configuration dispatchBatchSize];
}

- (NSUInteger) offlineDispatchQueueCapacity {

    return [self.configuration offlineDispatchQueueCapacity];
}

- (void) willEnqueueDispatch:(TEALDispatch *)dispatch {
    
}

- (void) didEnqueueDispatch:(TEALDispatch *)dispatch {
    
}

- (void) didUpdateDispatchQueues {
    
}

- (BOOL) hasDispatchExpired:(TEALDispatch *)dispatch {
    
    BOOL hasExpired = NO;
    
    return hasExpired;
}

- (void) willRunDispatchQueueWithCount:(NSUInteger)count {
    
}

- (void) didRunDispatchQueueWithCount:(NSUInteger)count {
    
}

#pragma mark - Archive I/O

- (void) unarchiveDispatchQueue {
    
    NSMutableArray *archivedDispatches = [[NSUserDefaults standardUserDefaults] objectForKey:AudienceStream_DispatchQueueKey];
    
    if (![archivedDispatches count]) {
        return;
    }
    

    for (id obj in archivedDispatches) {
        
        TEALDispatch *dispatch = nil;
        
        if ([obj isKindOfClass:[NSData class]]) {
            
            dispatch = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        }

        if (dispatch) {
            [self.dispatchManager.queuedDispatches enqueueObject:dispatch];
        }
    }
    
    NSUInteger dispatchCount = [self.dispatchManager queuedDispatchCount];
    
    if (dispatchCount) {
        TEAL_LogNormal(@"%lu archived dispatches have been enqueued.", (unsigned long)dispatchCount);
    }
}

- (void) archiveDispatchQueue {
    
    NSArray *queue = [self.dispatchManager.queuedDispatches allQueuedObjects];
    
    NSMutableArray *dataObjects = [NSMutableArray arrayWithCapacity:queue.count];
    
    for (id<NSCoding> obj in queue) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
        [dataObjects addObject:data];
    }
    
    dispatch_async(self.ioQueue, ^{
        
        [[NSUserDefaults standardUserDefaults] setObject:dataObjects
                                                  forKey:AudienceStream_DispatchQueueKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    
    NSUInteger count = [dataObjects count];
    
    if (count) {
        TEAL_LogNormal(@"%lu dispatches archived", count);
    }
}

@end
