//
//  TEALProfileStore.h
//  AudienceStream Library
//
//  Created by George Webster on 2/18/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TealiumUtilities/TEALBlocks.h>
#import "TEALProfileHelpers.h"

#import "TEALProfileDelegate.h"

@class TEALURLSessionManager;

@interface TEALProfileStore : NSObject

@property (readonly, nonatomic) TEALVisitorProfile *currentProfile;

@property (readonly, nonatomic) NSURL *profileURL;
@property (readonly, nonatomic) NSURL *profileDefinitionURL;

@property (weak, nonatomic) id<TEALProfileDelegate> profileDelegate;

- (instancetype) initWithURLSessionManager:(TEALURLSessionManager *)urlSessionManager
                                profileURL:(NSURL *)profileURL
                             definitionURL:(NSURL *)definitionURL
                                 visitorID:(NSString *)visitorID;

- (void) fetchProfileWithCompletion:(TEALProfileCompletionBlock)completion;

- (void) fetchProfileDefinitionsWithCompletion:(TEALDictionaryCompletionBlock)completion;



@end
