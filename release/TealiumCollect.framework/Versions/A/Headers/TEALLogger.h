//
//  TEALLog.h
//  Tealium Collect Library
//
//  Created by George Webster on 3/5/15.
//  Copyright (c) 2015 Tealium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALCollectConfiguration.h"

#define TEAL_LogNormal(s,...) [TEALLogger logTargetLevel:TEALCollectLogLevelNormal message:(s),##__VA_ARGS__];
#define TEAL_LogVerbose(s,...) [TEALLogger logTargetLevel:TEALCollectLogLevelVerbose message:(s),##__VA_ARGS__];
#define TEAL_LogExtreamVerbosity(s,...) [TEALLogger logTargetLevel:TEALCollectLogLevelExtremeVerbosity message:(s),##__VA_ARGS__];


@interface TEALLogger : NSObject

+ (void) setLogLevel:(TEALCollectLogLevel)logLevel;

+ (void) logTargetLevel:(TEALCollectLogLevel)targetLevel message:(NSString *)format, ...;

@end
