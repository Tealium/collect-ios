//
//  TEALVisitorProfileMetricAttribute.m
//  Tealium Collect Library
//
//  Created by George Webster on 6/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfileMetricAttribute.h"

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

- (BOOL) isEqualAttribute:(TEALVisitorProfileBaseAttribute *)attribute {
    
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
