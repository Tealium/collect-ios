//
//  TEALError.h
//  Tealium Collect Library
//
//  Created by George Webster on 3/16/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TEALErrorCode) {
    TEALErrorCodeUnknown        = -1,
    TEALErrorCodeSuccess        = 200,
    TEALErrorCodeNoContent      = 204,
    TEALErrorCodeMalformed      = 400,
    TEALErrorCodeFailure        = 404,
    TEALErrorCodeNotAcceptable  = 406,
    TEALErrorCodeException      = 555
};

extern NSString * const TEALAudienceStreamErrorDomain;

@interface TEALError : NSObject

+ (NSError *) errorWithCode:(NSInteger)code
                description:(NSString *)description
                     reason:(NSString *)reason
                 suggestion:(NSString *)suggestion;

+ (NSDictionary *) userInfoWithDescription:(NSString *)description
                                    reason:(NSString *)reason
                                suggestion:(NSString *)suggestion;

@end
