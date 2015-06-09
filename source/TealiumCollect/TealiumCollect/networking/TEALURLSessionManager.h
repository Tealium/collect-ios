//
//  TEALNetworkManager.h
//  AudienceStream Library
//
//  Created by George Webster on 2/27/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TealiumUtilities/TEALReachabilityManager.h>

#import <TealiumUtilities/TEALBlocks.h>

@interface TEALURLSessionManager : NSObject

@property (strong, nonatomic) TEALReachabilityManager *reachability;
@property (strong, nonatomic) dispatch_queue_t completionQueue;


- (instancetype) initWithConfiguration:(NSURLSessionConfiguration *)configuration;

- (void) performRequest:(NSURLRequest *)request withCompletion:(TEALHTTPResponseBlock)completion;

- (void) performRequest:(NSURLRequest *)request withJSONCompletion:(TEALHTTPResponseJSONBlock)completion;

@end
