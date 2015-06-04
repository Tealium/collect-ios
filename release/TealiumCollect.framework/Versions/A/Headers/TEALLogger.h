//
//  TEALLog.h
//  Tealium Collect Library
//
//  Created by George Webster on 3/5/15.
//  Copyright (c) 2015 Tealium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALCollectConfiguration.h"

#define TEAL_LogNormal(s,...) [TEALLogger logTargetLevel:TEALConnectLogLevelNormal message:(s),##__VA_ARGS__];
#define TEAL_LogVerbose(s,...) [TEALLogger logTargetLevel:TEALConnectLogLevelVerbose message:(s),##__VA_ARGS__];
#define TEAL_LogExtreamVerbosity(s,...) [TEALLogger logTargetLevel:TEALConnectLogLevelExtremeVerbosity message:(s),##__VA_ARGS__];


@interface TEALLogger : NSObject

+ (void) setLogLevel:(TEALConnectLogLevel)logLevel;

+ (void) logTargetLevel:(TEALConnectLogLevel)targetLevel message:(NSString *)format, ...;

@end
