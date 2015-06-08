//
//  TEALSystemHelpers.h
//  Tealium Collect Library
//
//  Created by George Webster on 12/29/14.
//  Copyright (c) 2014 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEALSystemHelpers : NSObject

+ (NSString *) tealiumIQlibraryVersion;

+ (NSString *) audienceStreamLibraryVersion;

+ (NSString *) mpsVersionNumber;

+ (NSString *) architecture;

+ (NSString *) bundleId;

+ (NSString *) bundleVersion;

+ (NSString *) cpuType;

+ (NSString *) applicationUUIDWithKey:(NSString *)key;

+ (NSString *) applicationName;

+ (NSString *) hardwareName;

+ (NSString *) timestampAsStringFromDate:(NSDate *)date;

@end
