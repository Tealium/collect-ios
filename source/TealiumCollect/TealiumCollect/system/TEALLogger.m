//
//  TEALLog.m
//  Tealium Collect Library
//
//  Created by George Webster on 3/5/15.
//  Copyright (c) 2015 Tealium. All rights reserved.
//

#import "TEALLogger.h"

static TEALCollectLogLevel _audienceStreamLogLevel;

@implementation TEALLogger

+ (void) setLogLevel:(TEALCollectLogLevel)logLevel {

    _audienceStreamLogLevel = logLevel;
}

+ (void) logTargetLevel:(TEALCollectLogLevel)targetLevel message:(NSString *)format, ... {

    BOOL shouldLog = NO;
    switch (targetLevel) {
        case TEALCollectLogLevelNormal:
            shouldLog = (_audienceStreamLogLevel >= TEALCollectLogLevelNormal);
            break;
        case TEALCollectLogLevelVerbose:
            shouldLog = (_audienceStreamLogLevel >= TEALCollectLogLevelVerbose);
            break;
        case TEALCollectLogLevelExtremeVerbosity:
            shouldLog = (_audienceStreamLogLevel >= TEALCollectLogLevelExtremeVerbosity);
            break;
        case TEALCollectLogLevelNone:
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
