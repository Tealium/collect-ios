//
//  TEALOperationManager.m
//  Tealium Collect Library
//
//  Created by George Webster on 2/25/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALOperationManager.h"

@interface TEALOperationManager ()

@property (strong, nonatomic) dispatch_queue_t serialQueue;
@property (strong, nonatomic) dispatch_queue_t ioQueue;

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation TEALOperationManager

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        _serialQueue = dispatch_queue_create("com.tealium.audience-stream", DISPATCH_QUEUE_SERIAL);
        _ioQueue = dispatch_queue_create("com.tealium.as-io-queue", DISPATCH_QUEUE_CONCURRENT);
        
        _operationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void) addOperationWithBlock:(TEALVoidBlock)block {
    
    dispatch_async(self.serialQueue, block);
}

- (dispatch_queue_t) underlyingQueue {

    return self.serialQueue;
}

- (void) addIOOperationWithBlock:(TEALVoidBlock)ioBlock {

    dispatch_async(self.ioQueue, ioBlock);
}

- (void) addOperation:(NSOperation *)operation {
    
    [self.operationQueue addOperation:operation];
}

@end
