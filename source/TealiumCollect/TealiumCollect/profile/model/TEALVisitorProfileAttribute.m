//
//  TEALVisitorProfileAttribute.m
//  Tealium Collect Library
//
//  Created by George Webster on 2/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfileAttribute.h"
#import <TealiumUtilities/NSString+TealiumAdditions.h>

@interface TEALVisitorProfileAttribute()

@property TEALVisitorProfileAttributeType type;

@end

@implementation TEALVisitorProfileAttribute

+ (instancetype) profileAttributeWithType:(TEALVisitorProfileAttributeType)type {

    return [[[self class] alloc] initWithType:type];
}

- (instancetype) initWithType:(TEALVisitorProfileAttributeType)type {

    self = [super init];
    
    if (self) {
        _type = type;
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {

    self = [super init];
    
    if (self) {
        _type = [aDecoder decodeIntegerForKey:@"type"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:self.type forKey:@"type"];
}

- (BOOL) isEqualAttribute:(TEALVisitorProfileAttribute *)attribute {
    
    if (![attribute isKindOfClass:[TEALVisitorProfileAttribute class]]) {
        return NO;
    }
    
    if (!self.attributeID || !attribute.attributeID) {
        return NO;
    }
    
    return [self.attributeID isEqualToString:attribute.attributeID];
}


@end

@implementation TEALVisitorProfileAudienceAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALVisitorProfileAttributeTypeAudience];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALVisitorProfileAudienceAttribute *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy.attributeID    = [self.attributeID copyWithZone:zone];
        copy.name           = [self.name copyWithZone:zone];
    }
    return copy;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (NSString *) description {
    
    return [NSString stringWithFormat:@"Audience Attribute: \r \
            id: %@  \r \
            name: %@",
            self.attributeID,
            self.name];
}

@end

@implementation TEALVisitorProfileBadgeAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALVisitorProfileAttributeTypeBadge];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALVisitorProfileBadgeAttribute *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy.attributeID    = [self.attributeID copyWithZone:zone];
        copy.name           = [self.name copyWithZone:zone];
    }
    return copy;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (NSString *) description {
    
    return [NSString stringWithFormat:@"Badge Attribute: \r \
            id: %@  \r \
            name: %@",
            self.attributeID,
            self.name];
}

@end

@implementation TEALVisitorProfileDateAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALVisitorProfileAttributeTypeDate];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALVisitorProfileDateAttribute *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy.attributeID    = [self.attributeID copyWithZone:zone];
        copy.timestamp      = self.timestamp;
    }
    return copy;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _timestamp = [aDecoder decodeDoubleForKey:@"timestamp"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeDouble:self.timestamp forKey:@"timestamp"];
}

- (BOOL) isEqualAttribute:(TEALVisitorProfileAttribute *)attribute {

    if (![super isEqualAttribute:attribute]) {
        return NO;
    }
    
    if (![attribute isKindOfClass:[TEALVisitorProfileDateAttribute class]]) {
        return NO;
    }

    TEALVisitorProfileDateAttribute *date = (TEALVisitorProfileDateAttribute *)attribute;

    if (!self.timestamp || !date.timestamp) {
        return NO;
    }
    
    return self.timestamp == date.timestamp;
}


- (NSString *) description {
    
    return [NSString stringWithFormat:@"Date Attribute: \r \
            id: %@  \r \
            timestamp: %f",
            self.attributeID,
            self.timestamp];
}

@end

@implementation TEALVisitorProfileFlagAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALVisitorProfileAttributeTypeFlag];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALVisitorProfileFlagAttribute *copy = [[[self class] allocWithZone:zone] init];

    if (copy) {
        copy.attributeID    = [self.attributeID copyWithZone:zone];
        copy.value          = self.value;
    }
    return copy;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _value = [aDecoder decodeBoolForKey:@"value"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeBool:self.value forKey:@"value"];
}

- (BOOL) isEqualAttribute:(TEALVisitorProfileAttribute *)attribute {
    
    if (![super isEqualAttribute:attribute]) {
        return NO;
    }
    
    if (![attribute isKindOfClass:[TEALVisitorProfileFlagAttribute class]]) {
        return NO;
    }
    
    TEALVisitorProfileFlagAttribute *flag = (TEALVisitorProfileFlagAttribute *)attribute;
    
    return self.value == flag.value;
}

- (NSString *) description {
    
    NSString *valueString = [NSString teal_stringFromBool:self.value];
    
    return [NSString stringWithFormat:@"Flag Attribute: \r \
            id: %@  \r \
            value: %@",
            self.attributeID,
            valueString];
}

@end

@implementation TEALVisitorProfileMetricAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALVisitorProfileAttributeTypeMetric];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALVisitorProfileMetricAttribute *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy.attributeID    = [self.attributeID copyWithZone:zone];
        copy.value          = self.value;
    }
    return copy;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _value = [aDecoder decodeFloatForKey:@"value"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeFloat:self.value forKey:@"value"];
}

- (BOOL) isEqualAttribute:(TEALVisitorProfileAttribute *)attribute {
    
    if (![super isEqualAttribute:attribute]) {
        return NO;
    }
    
    if (![attribute isKindOfClass:[TEALVisitorProfileMetricAttribute class]]) {
        return NO;
    }
    
    TEALVisitorProfileMetricAttribute *metric = (TEALVisitorProfileMetricAttribute *)attribute;
    
    return self.value == metric.value;
}

- (NSString *) description {
    
    return [NSString stringWithFormat:@"Metric Attribute: \r \
            id: %@  \r \
            value: %f",
            self.attributeID,
            self.value];
}

@end

@implementation TEALVisitorProfilePropertyAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALVisitorProfileAttributeTypeProperty];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALVisitorProfilePropertyAttribute *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy.attributeID    = [self.attributeID copyWithZone:zone];
        copy.value          = [self.value copyWithZone:zone];
    }
    return copy;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _value = [aDecoder decodeObjectForKey:@"value"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.value forKey:@"value"];
}

- (BOOL) isEqualAttribute:(TEALVisitorProfileAttribute *)attribute {
    
    if (![super isEqualAttribute:attribute]) {
        return NO;
    }
    
    if (![attribute isKindOfClass:[TEALVisitorProfilePropertyAttribute class]]) {
        return NO;
    }
    
    TEALVisitorProfilePropertyAttribute *property = (TEALVisitorProfilePropertyAttribute *)attribute;
    
    if (!self.value || !property.value) {
        return NO;
    }
    
    return [self.value isEqualToString:property.value];
}

- (NSString *) description {
    
    return [NSString stringWithFormat:@"Property Attribute: \r \
            id: %@  \r \
            value: %@",
            self.attributeID,
            self.value];
}

@end
