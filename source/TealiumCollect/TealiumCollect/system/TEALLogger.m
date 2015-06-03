//
//  TEALLog.m
//  Tealium Collect Library
//
//  Created by George Webster on 3/5/15.
//  Copyright (c) 2015 Tealium. All rights reserved.
//

#import "TEALLogger.h"

static TEALConnectLogLevel _audienceStreamLogLevel;

@implementation TEALLogger

+ (void) setLogLevel:(TEALConnectLogLevel)logLevel {

    _audienceStreamLogLevel = logLevel;
}

+ (void) logTargetLevel:(TEALConnectLogLevel)targetLevel message:(NSString *)format, ... {

    BOOL shouldLog = NO;
    switch (targetLevel) {
        case TEALConnectLogLevelNormal:
            shouldLog = (_audienceStreamLogLevel >= TEALConnectLogLevelNormal);
            break;
        case TEALConnectLogLevelVerbose:
            shouldLog = (_audienceStreamLogLevel >= TEALConnectLogLevelVerbose);
            break;
        case TEALConnectLogLevelExtremeVerbosity:
            shouldLog = (_audienceStreamLogLevel >= TEALConnectLogLevelExtremeVerbosity);
            break;
        case TEALConnectLogLevelNone:
            shouldLog = NO;
            break;
    }
    
    if (shouldLog && format) {

        NSString *message = nil;
        va_list args;
        va_start(args, format);
        message = [[NSString alloc] initWithFormat:format
                                         arguments:args];
        va_end(args);

        NSLog(@"%@", message);
    }
}

@end
