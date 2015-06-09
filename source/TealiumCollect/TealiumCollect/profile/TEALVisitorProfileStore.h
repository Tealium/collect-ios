//
//  TEALVisitorProfileStore.h
//  Tealium Collect Library
//
//  Created by George Webster on 2/18/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TealiumUtilities/TEALBlocks.h>
#import "TEALVisitorProfileHelpers.h"

#import "TEALVisitorProfileDelegate.h"

@class TEALURLSessionManager;

@interface TEALVisitorProfileStore : NSObject

@property (readonly, nonatomic) TEALVisitorProfile *currentProfile;

@property (readonly, nonatomic) NSURL *profileURL;
@property (readonly, nonatomic) NSURL *profileDefinitionURL;

@property (weak, nonatomic) id<TEALVisitorProfileDelegate> profileDelegate;

- (instancetype) initWithURLSessionManager:(TEALURLSessionManager *)urlSessionManager
                                profileURL:(NSURL *)profileURL
                             definitionURL:(NSURL *)definitionURL
                                 visitorID:(NSString *)visitorID;

- (void) fetchProfileWithCompletion:(TEALVisitorProfileCompletionBlock)completion;

- (void) fetchProfileDefinitionsWithCompletion:(TEALDictionaryCompletionBlock)completion;



@end
