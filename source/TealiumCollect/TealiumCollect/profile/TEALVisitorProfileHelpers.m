//
//  TEALVisitorProfileHelpers.m
//  Tealium Collect Library
//
//  Created by George Webster on 3/10/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfileHelpers.h"

#import "TEALVisitorProfileAudienceAttribute.h"
#import "TEALVisitorProfileBadgeAttribute.h"
#import "TEALVisitorProfileDateAttribute.h"
#import "TEALVisitorProfileFlagAttribute.h"
#import "TEALVisitorProfileMetricAttribute.h"
#import "TEALVisitorProfilePropertyAttribute.h"

@implementation TEALVisitorProfileHelpers

+ (NSString *)keypathForAttributeType:(TEALVisitorProfileAttributeType)type {
    
    NSString *keypath = nil;
    
    switch (type) {
        case TEALVisitorProfileAttributeTypeAudience:
            keypath = @"audiences";
            break;
        case TEALVisitorProfileAttributeTypeBadge:
            keypath = @"badges";
            break;
        case TEALVisitorProfileAttributeTypeDate:
            keypath = @"dates";
            break;
        case TEALVisitorProfileAttributeTypeFlag:
            keypath = @"flages";
            break;
        case TEALVisitorProfileAttributeTypeMetric:
            keypath = @"metrics";
            break;
        case TEALVisitorProfileAttributeTypeProperty:
            keypath = @"properties";
            break;
        default:
            break;
    }
    
    return keypath;
}

+ (NSArray *) arrayOfAttrubutesForType:(TEALVisitorProfileAttributeType)type
                            fromSource:(NSDictionary *)sourceProfile
                             withBlock:(TEALVisitorProfileAttributeCreationBlock)block {
    
    NSString *keypath = [TEALVisitorProfileHelpers keypathForAttributeType:type];
    
    NSDictionary *sourceAttributes = sourceProfile[keypath];
    
    if (!sourceAttributes) {
        return nil;
    }
    
    NSMutableArray *tempAttributes = [NSMutableArray arrayWithCapacity:sourceAttributes.count];
    
    [sourceAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        TEALVisitorProfileBaseAttribute *attribute = block(key, obj);
        
        [tempAttributes addObject:attribute];
        
        *stop = YES; // should only be one key/value pair but just in case
    }];
    
    return [NSArray arrayWithArray:tempAttributes];
}


+ (NSArray *) arrayOfAudiencesFromSource:(NSDictionary *)source {
    
    TEALVisitorProfileAttributeCreationBlock attributeBlock = ^TEALVisitorProfileBaseAttribute *(id key, id obj) {
        
        TEALVisitorProfileAudienceAttribute *attribute = [TEALVisitorProfileAudienceAttribute new];
        
        attribute.attributeID = key;
        attribute.name = obj;
        
        return attribute;
    };
    
    return [TEALVisitorProfileHelpers arrayOfAttrubutesForType:TEALVisitorProfileAttributeTypeAudience
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfBadgesFromSource:(NSDictionary *)source {
    
    TEALVisitorProfileAttributeCreationBlock attributeBlock = ^TEALVisitorProfileBaseAttribute *(id key, id obj) {
        
        TEALVisitorProfileBadgeAttribute *attribute = [TEALVisitorProfileBadgeAttribute new];
        
        attribute.attributeID = key;
        
        return attribute;
    };
    
    return [TEALVisitorProfileHelpers arrayOfAttrubutesForType:TEALVisitorProfileAttributeTypeBadge
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfDatesFromSource:(NSDictionary *)source {
    
    TEALVisitorProfileAttributeCreationBlock attributeBlock = ^TEALVisitorProfileBaseAttribute *(id key, id obj) {
        
        TEALVisitorProfileDateAttribute *attribute = [TEALVisitorProfileDateAttribute new];
        
        attribute.attributeID = key;
        
        if ([obj respondsToSelector:@selector(doubleValue)]) {
            attribute.timestamp = [obj doubleValue];
        }
        
        return attribute;

    };
    
    return [TEALVisitorProfileHelpers arrayOfAttrubutesForType:TEALVisitorProfileAttributeTypeDate
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfFlagsFromSource:(NSDictionary *)source {

    TEALVisitorProfileAttributeCreationBlock attributeBlock = ^TEALVisitorProfileBaseAttribute *(id key, id obj) {
        
        TEALVisitorProfileFlagAttribute *attribute = [TEALVisitorProfileFlagAttribute new];
        
        attribute.attributeID = key;
        
        if ([obj respondsToSelector:@selector(boolValue)]) {
            attribute.value = [obj boolValue];
        }
        
        return attribute;
    };
    
    return [TEALVisitorProfileHelpers arrayOfAttrubutesForType:TEALVisitorProfileAttributeTypeFlag
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfMetricsFromSource:(NSDictionary *)source {
    
    TEALVisitorProfileAttributeCreationBlock attributeBlock = ^TEALVisitorProfileBaseAttribute *(id key, id obj) {
        
        TEALVisitorProfileMetricAttribute *attribute = [TEALVisitorProfileMetricAttribute new];
        
        attribute.attributeID = key;
        
        if ([obj respondsToSelector:@selector(floatValue)]) {
            attribute.value = [obj floatValue];
        }
        
        return attribute;
    };
    
    return [TEALVisitorProfileHelpers arrayOfAttrubutesForType:TEALVisitorProfileAttributeTypeMetric
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfPropertiesFromSource:(NSDictionary *)source {
    
    TEALVisitorProfileAttributeCreationBlock attributeBlock = ^TEALVisitorProfileBaseAttribute *(id key, id obj) {
        
        TEALVisitorProfilePropertyAttribute *attribute = [TEALVisitorProfilePropertyAttribute new];
        
        attribute.attributeID = key;
        
        attribute.value = obj;
        
        return attribute;
    };
    
    return [TEALVisitorProfileHelpers arrayOfAttrubutesForType:TEALVisitorProfileAttributeTypeProperty
                                                    fromSource:source
                                                     withBlock:attributeBlock];
}

@end
