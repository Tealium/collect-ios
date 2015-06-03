//
//  TEALDataQueue.h
//  TealiumUtilities
//
//  Created by George Webster on 1/19/15.
//  Copyright (c) 2015 Tealium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEALDataQueue : NSObject

+ (instancetype) queueWithCapacity:(NSUInteger)capacity;

- (instancetype) initWithCapacity:(NSUInteger)capacity;

- (id) enqueueObject:(id)obj;

- (id) enqueueObjectToFirstPosition:(id)obj;

- (id) dequeueObject;

- (NSUInteger) count;

- (NSArray *) allQueuedObjects;
- (NSArray *) queuedObjectsOrderedWithLimit:(NSUInteger)numberOfItems;

- (void) updateCapacity:(NSUInteger)capacity;

- (void) dequeueAllObjects;

- (void) dequeueNumberOfObjects:(NSUInteger)numberOfObjects withBlock:(void (^)(id dequeuedObject))block;

- (void) dequeueObjects:(NSArray *)objects withBlock:(void (^)(id dequeuedObject))block;

- (void) enumerateQueuedObjectsUsingBlock:(void (^)(id obj,
                                                    NSUInteger idx,
                                                    BOOL *stop))block;


@end
