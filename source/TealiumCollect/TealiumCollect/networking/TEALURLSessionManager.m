//
//  TEALNetworkManager.m
//  AudienceStream Library
//
//  Created by George Webster on 2/27/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALURLSessionManager.h"

#import "TEALLogger.h"

@interface TEALURLSessionManager () <NSURLSessionDelegate>

@property (strong, nonatomic) NSURLSession *urlSession;
@property (strong, nonatomic) NSOperationQueue *sessionQueue;

@end

@implementation TEALURLSessionManager

- (instancetype) initWithConfiguration:(NSURLSessionConfiguration *)configuration {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    _reachability = [TEALReachabilityManager reachabilityWithHostname:@"www.google.com"];

    _sessionQueue = [[NSOperationQueue alloc] init];
    _sessionQueue.maxConcurrentOperationCount =1;
    
    _urlSession = [NSURLSession sessionWithConfiguration:configuration
                                                delegate:self
                                           delegateQueue:_sessionQueue];
    return self;
}

- (void) performRequest:(NSURLRequest *)request withCompletion:(TEALHTTPResponseBlock)completion {

    TEAL_LogExtreamVerbosity(@"URL Session Manager sending request: %@", request);
    
    TEALURLTaskResponseBlock taskCompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {

        dispatch_queue_t targetQueue = self.completionQueue;
        
        if (!targetQueue) {
            targetQueue = dispatch_get_main_queue();
        }
        
        dispatch_async(targetQueue, ^{
            
            TEAL_LogExtreamVerbosity(@"URL Session Manager  received response: %@", response);

            completion( (NSHTTPURLResponse *)response, data, error );
        });
    };
    
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:request
                                                completionHandler:taskCompletion];
    

    [task resume];
}

- (void) performRequest:(NSURLRequest *)request withJSONCompletion:(TEALHTTPResponseJSONBlock)completion {

    [self performRequest:request
          withCompletion:^(NSHTTPURLResponse *response, NSData *data, NSError *connectionError) {
              
              NSDictionary *jsonData = nil;
              
              if (data) {
                  
                  NSError *jsonError = nil;
                  
                  id json = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&jsonError];
                  
                  if (!json) {
                      connectionError = jsonError;
                  }
                  
                  if ([json isKindOfClass:[NSDictionary class]]) {
                      jsonData = json;
                  } else {
                      // TODO do an error, we are only handling JSON root dicts not arrays
                  }
              }

              completion( response, jsonData, connectionError );
          }];

}

@end
