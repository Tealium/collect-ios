//
//  TEALActionQueueManager.h
//  Tealium Collect Library
//
//  Created by George Webster on 1/9/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TealiumUtilities/TEALBlocks.h>

@interface TEALActionQueueManager : NSObject

- (void) enqueueActionWithBlock:(TEALVoidBlock)block;
- (void) runQueuedActions;

@end
