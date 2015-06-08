//
//  TEALNetworkHelpers.h
//  AudienceStream Library
//
//  Created by George Webster on 12/29/14.
//  Copyright (c) 2014 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALEvent.h"

@interface TEALNetworkHelpers : NSObject

+ (NSString *) urlParamStringFromDictionary:(NSDictionary *)data;

+ (NSString *) appendUrlParamString:(NSString *)urlString withDictionary:(NSDictionary *)data;

+ (NSString *) percentEscapeURLParameter:(NSString *)string;

+ (NSDictionary *) dictionaryFromUrlParamString:(NSString *)string;

+ (NSURLRequest *) requestWithURLString:(NSString *)urlString;

+ (NSURLRequest *) requestWithURL:(NSURL *)url;

+ (NSURLRequest *) requestWithURLString:(NSString *)urlString
                                 method:(NSString *)methodString
                                   body:(NSData *)bodyData;

+ (NSString *) eventStringFromType:(TEALEventType)eventType;

@end
