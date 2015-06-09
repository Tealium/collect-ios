//
//  TEALError.m
//  Tealium Collect Library
//
//  Created by George Webster on 3/16/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALError.h"

NSString * const TEALAudienceStreamErrorDomain = @"com.tealium.audience-stream";

@implementation TEALError

+ (NSError *) errorWithCode:(NSInteger)code
                description:(NSString *)description
                     reason:(NSString *)reason
                 suggestion:(NSString *)suggestion {
    
    NSDictionary *userInfo = [TEALError userInfoWithDescription:description
                                                         reason:reason
                                                     suggestion:suggestion];

    return [NSError errorWithDomain:TEALAudienceStreamErrorDomain
                               code:code
                           userInfo:userInfo];
}

+ (NSDictionary *) userInfoWithDescription:(NSString *)description
                                    reason:(NSString *)reason
                                suggestion:(NSString *)suggestion {

    if (!description) {
        description = @"";
    }
    
    if (!reason) {
        reason = @"";
    }
    
    if (!suggestion) {
        suggestion = @"";
    }
    
    return @{NSLocalizedDescriptionKey: description,
             NSLocalizedFailureReasonErrorKey: reason,
             NSLocalizedRecoverySuggestionErrorKey: suggestion};
}

@end
