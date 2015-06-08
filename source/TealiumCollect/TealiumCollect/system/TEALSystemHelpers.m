//
//  TEALSystemHelpers.m
//  Tealium Collect Library
//
//  Created by George Webster on 12/29/14.
//  Copyright (c) 2014 Tealium Inc. All rights reserved.
//

#import "TEALSystemHelpers.h"

#import <sys/types.h>
#import <sys/sysctl.h>
#import <mach/machine.h>

NSString * const kTEALApplicationUUIDKey = @"com.tealium.applicationUUID";

NSString * const kTEALAudienceStreamVersion = @"1.0";


@implementation TEALSystemHelpers

+ (NSString *) tealiumIQlibraryVersion {
    return @"TiQ_4.1.2";
}

+ (NSString *) audienceStreamLibraryVersion {
    return [@"AS_" stringByAppendingString:kTEALAudienceStreamVersion];
}

+ (NSString *) mpsVersionNumber {
    
    NSString *tiq = [[self class] tealiumIQlibraryVersion];
    
    NSRange range = [tiq rangeOfString:@"."];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    return [tiq substringToIndex:range.location];
}

+ (NSString *) architecture {
    if(sizeof(int*) == 4) {
        return @"32";
    } else if(sizeof(int*) == 8) {
        return @"64";
    }
    return nil;
}

+ (NSString *) bundleId {
    NSBundle *bundle = [NSBundle mainBundle];
    
    if (bundle) {
        return [bundle bundleIdentifier];
    }
    return nil;
}

+ (NSString *) bundleVersion {
    NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
    
    NSString *version = [bundle objectForKey:@"CFBundleShortVersionString"];
    
    if (version == nil) {
        version = [bundle objectForKey:@"CFBundleVersion"];
    }
    return version;
}

+ (NSString *) cpuType {
    NSMutableString *cpu = [NSMutableString string];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_X86) {
        
        [cpu appendString:@"x86 "];
        
    } else if (type == CPU_TYPE_ARM) { // check for subtype ...
        
        [cpu appendString:@"ARM"];
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"V7"];
                break;
            case CPU_SUBTYPE_ARM_V7EM:
                [cpu appendString:@"V7em"];
                break;
            case CPU_SUBTYPE_ARM_V7F:
                [cpu appendString:@"V7f"];
                break;
            case CPU_SUBTYPE_ARM_V7K:
                [cpu appendString:@"V7k"];
                break;
            case CPU_SUBTYPE_ARM_V7M:
                [cpu appendString:@"V7m"];
                break;
            case CPU_SUBTYPE_ARM_V7S:
                [cpu appendString:@"V7s"];
                break;
            case CPU_SUBTYPE_ARM_V6:
                [cpu appendString:@"V6"];
                break;
            case CPU_SUBTYPE_ARM_V6M:
                [cpu appendString:@"V6m"];
                break;
            case CPU_SUBTYPE_ARM_V8:
                [cpu appendString:@"V8"];
                break;
            case CPU_SUBTYPE_386:
                [cpu appendString:@"386"];
                break;
            case CPU_SUBTYPE_486:
                [cpu appendString:@"486"];
                break;
            case CPU_SUBTYPE_486SX:
                [cpu appendString:@"486sx"];
                break;
            case CPU_SUBTYPE_586:
                [cpu appendString:@"586"];
                break;
                // ...
        }
    }
    return cpu;
}

+ (NSString *) applicationUUIDWithKey:(NSString *)key {
    
    NSString *keyString = [kTEALApplicationUUIDKey stringByAppendingString:key];
    
    NSString *applicationUUID = [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
    
    if (!applicationUUID) {
        applicationUUID = [[NSUUID UUID] UUIDString];

        [[NSUserDefaults standardUserDefaults] setObject:applicationUUID
                                                  forKey:keyString];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return applicationUUID;
}

+ (NSString *) applicationName {
    
    NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];

    return [bundle objectForKey:@"CFBundleName"];
}

+ (NSString *) hardwareName {
    NSString *hardwareName = nil;
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    hardwareName = [NSString stringWithUTF8String:machine];
    free(machine);

    return hardwareName;
}

+ (NSString *) timestampAsStringFromDate:(NSDate *)date {
    NSTimeInterval ti = [date timeIntervalSince1970];
    return [@(ti) stringValue];
}

@end
