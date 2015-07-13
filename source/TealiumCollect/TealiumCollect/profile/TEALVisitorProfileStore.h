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

#import "TEALSystemProtocols.h"

@protocol TEALVisitorProfileStoreConfiguration <NSObject, TEALURLSessions>

- (NSURL *) profileURL;
- (NSURL *) profileDefinitionURL;

- (NSString *) visitorID;
@end

@interface TEALVisitorProfileStore : NSObject

@property (readonly, nonatomic) TEALVisitorProfile *currentProfile;
@property (weak, nonatomic) id<TEALVisitorProfileStoreConfiguration> configuration;

@property (weak, nonatomic) id<TEALVisitorProfileDelegate> profileDelegate;

- (instancetype) initWithConfiguration:(id<TEALVisitorProfileStoreConfiguration>)configuration;

- (void) fetchProfileWithCompletion:(TEALVisitorProfileCompletionBlock)completion;

- (void) fetchProfileDefinitionsWithCompletion:(TEALDictionaryCompletionBlock)completion;



@end
