//
//  TEALAudienceStreamAPIHelpers.m
//  ASTester
//
//  Created by George Webster on 4/17/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALAudienceStreamAPIHelpers.h"
#import "TEALSettings.h"
#import "TEALAudienceStreamDatasources.h"
#import "TEALNetworkHelpers.h"

@implementation TEALAudienceStreamAPIHelpers

+ (NSURL *) profileURLFromSettings:(TEALSettings *)settings {
    
    if (![settings isValid]) {
        return nil;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://visitor-service.tealiumiq.com/%@/%@/%@",
                           settings.account,
                           settings.asProfile,
                           settings.visitorID];

    return [NSURL URLWithString:urlString];
}


+ (NSURL *) profileDefinitionsURLFromSettings:(TEALSettings *)settings {
    
    if (![settings isValid]) {
        return nil;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://visitor-service.tealiumiq.com/datacloudprofiledefinitions/%@/%@",
                           settings.account,
                           settings.asProfile];
    
    return [NSURL URLWithString:urlString];
}

+ (NSString *) sendDataURLStringFromSettings:(TEALSettings *)settings {
    
    if (![settings isValid]) {
        return nil;
    }
    
    NSString *urlPrefix = @"https";
    
    if (settings.useHTTP) {
        urlPrefix = @"http";
    }
    
    NSString *baseURLString = [NSString stringWithFormat:@"%@://datacloud.tealiumiq.com/vdata/i.gif?", urlPrefix];

    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[TEALAudienceStreamKey_Account]   = settings.account;
    params[TEALAudienceStreamKey_Profile]   = settings.asProfile;
    params[TEALAudienceStreamKey_VisitorID] = settings.visitorID;

    if (settings.traceID) {
        params[TEALAudienceStreamKey_TraceID] = settings.traceID;
    }
    
    NSString *queryString = [TEALNetworkHelpers urlParamStringFromDictionary:params];
    
    return [baseURLString stringByAppendingString:queryString];
}

#pragma MPS / Mobile Publish Settings Helpers
               
+ (NSString *) mobilePublishSettingsURLStringFromSettings:(TEALSettings *)settings {
    
    if (![settings isValid]) {
        return nil;
    }
    
    NSString *urlPrefix = @"https:";
    
    if (settings.useHTTP) {
        urlPrefix = @"http:";
    }
    
    return [NSString stringWithFormat:@"%@//tags.tiqcdn.com/utag/%@/%@/%@/mobile.html?",
            urlPrefix,
            settings.account,
            settings.tiqProfile,
            settings.environment];
}

@end
