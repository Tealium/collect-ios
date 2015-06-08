//
//  TEALSystemProtocols.h
//  Tealium Collect Library
//
//  Created by George Webster on 4/17/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEALOperationManager;
@class TEALURLSessionManager;

@protocol TEALOperations <NSObject>

- (TEALOperationManager *) operationManager;

@end

@protocol TEALURLSessions <NSObject>

- (TEALURLSessionManager *) urlSessionManager;

@end
