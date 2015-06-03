//
//  TEALProfileHelpers.m
//  ASTester
//
//  Created by George Webster on 3/10/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALProfileHelpers.h"



@implementation TEALProfileHelpers

+ (NSString *)keypathForAttributeType:(TEALProfileAttributeType)type {
    
    NSString *keypath = nil;
    
    switch (type) {
        case TEALProfileAttributeTypeAudience:
            keypath = @"audiences";
            break;
        case TEALProfileAttributeTypeBadge:
            keypath = @"badges";
            break;
        case TEALProfileAttributeTypeDate:
            keypath = @"dates";
            break;
        case TEALProfileAttributeTypeFlag:
            keypath = @"flages";
            break;
        case TEALProfileAttributeTypeMetric:
            keypath = @"metrics";
            break;
        case TEALProfileAttributeTypeProperty:
            keypath = @"properties";
            break;
        default:
            break;
    }
    
    return keypath;
}

+ (NSArray *) arrayOfAttrubutesForType:(TEALProfileAttributeType)type
                            fromSource:(NSDictionary *)sourceProfile
                             withBlock:(TEALProfileAttributeCreationBlock)block {
    
    NSString *keypath = [TEALProfileHelpers keypathForAttributeType:type];
    
    NSDictionary *sourceAttributes = sourceProfile[keypath];
    
    if (!sourceAttributes) {
        return nil;
    }
    
    NSMutableArray *tempAttributes = [NSMutableArray arrayWithCapacity:sourceAttributes.count];
    
    [sourceAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        TEALProfileAttribute *attribute = block(key, obj);
        
        [tempAttributes addObject:attribute];
        
        *stop = YES; // should only be one key/value pair but just in case
    }];
    
    return [NSArray arrayWithArray:tempAttributes];
}


+ (NSArray *) arrayOfAudiencesFromSource:(NSDictionary *)source {
    
    TEALProfileAttributeCreationBlock attributeBlock = ^TEALProfileAttribute *(id key, id obj) {
        
        TEALProfileAudienceAttribute *attribute = [TEALProfileAudienceAttribute new];
        
        attribute.attributeID = key;
        attribute.name = obj;
        
        return attribute;
    };
    
    return [TEALProfileHelpers arrayOfAttrubutesForType:TEALProfileAttributeTypeAudience
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfBadgesFromSource:(NSDictionary *)source {
    
    TEALProfileAttributeCreationBlock attributeBlock = ^TEALProfileAttribute *(id key, id obj) {
        
        TEALProfileBadgeAttribute *attribute = [TEALProfileBadgeAttribute new];
        
        attribute.attributeID = key;
        
        return attribute;
    };
    
    return [TEALProfileHelpers arrayOfAttrubutesForType:TEALProfileAttributeTypeBadge
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfDatesFromSource:(NSDictionary *)source {
    
    TEALProfileAttributeCreationBlock attributeBlock = ^TEALProfileAttribute *(id key, id obj) {
        
        TEALProfileDateAttribute *attribute = [TEALProfileDateAttribute new];
        
        attribute.attributeID = key;
        
        if ([obj respondsToSelector:@selector(doubleValue)]) {
            attribute.timestamp = [obj doubleValue];
        }
        
        return attribute;

    };
    
    return [TEALProfileHelpers arrayOfAttrubutesForType:TEALProfileAttributeTypeDate
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfFlagsFromSource:(NSDictionary *)source {

    TEALProfileAttributeCreationBlock attributeBlock = ^TEALProfileAttribute *(id key, id obj) {
        
        TEALProfileFlagAttribute *attribute = [TEALProfileFlagAttribute new];
        
        attribute.attributeID = key;
        
        if ([obj respondsToSelector:@selector(boolValue)]) {
            attribute.value = [obj boolValue];
        }
        
        return attribute;
    };
    
    return [TEALProfileHelpers arrayOfAttrubutesForType:TEALProfileAttributeTypeFlag
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfMetricsFromSource:(NSDictionary *)source {
    
    TEALProfileAttributeCreationBlock attributeBlock = ^TEALProfileAttribute *(id key, id obj) {
        
        TEALProfileMetricAttribute *attribute = [TEALProfileMetricAttribute new];
        
        attribute.attributeID = key;
        
        if ([obj respondsToSelector:@selector(floatValue)]) {
            attribute.value = [obj floatValue];
        }
        
        return attribute;
    };
    
    return [TEALProfileHelpers arrayOfAttrubutesForType:TEALProfileAttributeTypeMetric
                                             fromSource:source
                                              withBlock:attributeBlock];
}

+ (NSArray *) arrayOfPropertiesFromSource:(NSDictionary *)source {
    
    TEALProfileAttributeCreationBlock attributeBlock = ^TEALProfileAttribute *(id key, id obj) {
        
        TEALProfilePropertyAttribute *attribute = [TEALProfilePropertyAttribute new];
        
        attribute.attributeID = key;
        
        attribute.value = obj;
        
        return attribute;
    };
    
    return [TEALProfileHelpers arrayOfAttrubutesForType:TEALProfileAttributeTypeProperty
                                             fromSource:source
                                              withBlock:attributeBlock];
}

@end
