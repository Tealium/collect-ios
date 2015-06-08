//
//  TEALBlocks.h
//  TealiumUtilities
//
//  Created by George Webster on 2/11/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

typedef void (^TEALVoidBlock)(void);

typedef void (^TEALBooleanBlock)(BOOL successful);

typedef void (^TEALBooleanCompletionBlock)(BOOL success, NSError *error);

typedef void (^TEALDictionaryCompletionBlock)(NSDictionary *dataDictionary, NSError *error);

typedef void (^TEALURLResponseBlock)(NSURLResponse *response, NSData *data, NSError *connectionError);
typedef void (^TEALURLTaskResponseBlock)(NSData *data, NSURLResponse *response, NSError *connectionError);

typedef void (^TEALHTTPResponseBlock)(NSHTTPURLResponse *response, NSData *data, NSError *connectionError);

typedef void (^TEALHTTPResponseJSONBlock)(NSHTTPURLResponse *response, NSDictionary *data, NSError *connectionError);
