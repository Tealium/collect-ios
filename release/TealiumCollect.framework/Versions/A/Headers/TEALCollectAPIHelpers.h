//
//  TEALAudienceStreamAPIHelpers.h
//  Tealium Collect Library
//
//  Created by George Webster on 4/17/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEALSettings;

@interface TEALCollectAPIHelpers : NSObject

#pragma mark - Get Data

+ (NSURL *) profileURLFromSettings:(TEALSettings *)settings;
+ (NSURL *) profileDefinitionsURLFromSettings:(TEALSettings *)settings;

#pragma mark - Send Data

+ (NSString *) sendDataURLStringFromSettings:(TEALSettings *)settings;

#pragma MPS / Mobile Publish Settings Helpers

+ (NSString *) mobilePublishSettingsURLStringFromSettings:(TEALSettings *)settings;

@end
