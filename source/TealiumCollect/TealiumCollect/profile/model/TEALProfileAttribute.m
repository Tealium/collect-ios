//
//  TEALProfileAttribute.m
//  TEALAudienceStream
//
//  Created by George Webster on 2/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALProfileAttribute.h"
#import <TealiumUtilities/NSString+TealiumAdditions.h>

@interface TEALProfileAttribute()

@property TEALProfileAttributeType type;

@end

@implementation TEALProfileAttribute

+ (instancetype) profileAttributeWithType:(TEALProfileAttributeType)type {

    return [[[self class] alloc] initWithType:type];
}

- (instancetype) initWithType:(TEALProfileAttributeType)type {

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

- (BOOL) isEqualAttribute:(TEALProfileAttribute *)attribute {
    
    if (![attribute isKindOfClass:[TEALProfileAttribute class]]) {
        return NO;
    }
    
    if (!self.attributeID || !attribute.attributeID) {
        return NO;
    }
    
    return [self.attributeID isEqualToString:attribute.attributeID];
}


@end

@implementation TEALProfileAudienceAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALProfileAttributeTypeAudience];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALProfileAudienceAttribute *copy = [[[self class] allocWithZone:zone] init];
    
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

@implementation TEALProfileBadgeAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALProfileAttributeTypeBadge];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALProfileBadgeAttribute *copy = [[[self class] allocWithZone:zone] init];
    
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

@implementation TEALProfileDateAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALProfileAttributeTypeDate];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALProfileDateAttribute *copy = [[[self class] allocWithZone:zone] init];
    
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

- (BOOL) isEqualAttribute:(TEALProfileAttribute *)attribute {

    if (![super isEqualAttribute:attribute]) {
        return NO;
    }
    
    if (![attribute isKindOfClass:[TEALProfileDateAttribute class]]) {
        return NO;
    }

    TEALProfileDateAttribute *date = (TEALProfileDateAttribute *)attribute;

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

@implementation TEALProfileFlagAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALProfileAttributeTypeFlag];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALProfileFlagAttribute *copy = [[[self class] allocWithZone:zone] init];

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

- (BOOL) isEqualAttribute:(TEALProfileAttribute *)attribute {
    
    if (![super isEqualAttribute:attribute]) {
        return NO;
    }
    
    if (![attribute isKindOfClass:[TEALProfileFlagAttribute class]]) {
        return NO;
    }
    
    TEALProfileFlagAttribute *flag = (TEALProfileFlagAttribute *)attribute;
    
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

@implementation TEALProfileMetricAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALProfileAttributeTypeMetric];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALProfileMetricAttribute *copy = [[[self class] allocWithZone:zone] init];
    
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

- (BOOL) isEqualAttribute:(TEALProfileAttribute *)attribute {
    
    if (![super isEqualAttribute:attribute]) {
        return NO;
    }
    
    if (![attribute isKindOfClass:[TEALProfileMetricAttribute class]]) {
        return NO;
    }
    
    TEALProfileMetricAttribute *metric = (TEALProfileMetricAttribute *)attribute;
    
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

@implementation TEALProfilePropertyAttribute

- (instancetype) init {
    
    self = [super initWithType:TEALProfileAttributeTypeProperty];
    
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALProfilePropertyAttribute *copy = [[[self class] allocWithZone:zone] init];
    
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

- (BOOL) isEqualAttribute:(TEALProfileAttribute *)attribute {
    
    if (![super isEqualAttribute:attribute]) {
        return NO;
    }
    
    if (![attribute isKindOfClass:[TEALProfilePropertyAttribute class]]) {
        return NO;
    }
    
    TEALProfilePropertyAttribute *property = (TEALProfilePropertyAttribute *)attribute;
    
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
