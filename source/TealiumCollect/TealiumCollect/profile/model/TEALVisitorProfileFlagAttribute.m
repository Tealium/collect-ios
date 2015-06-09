//
//  TEALVisitorProfileFlagAttribute.m
//  Tealium Collect Library
//
//  Created by George Webster on 6/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfileFlagAttribute.h"

#import <TealiumUtilities/NSString+TealiumAdditions.h>

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

- (BOOL) isEqualAttribute:(TEALVisitorProfileBaseAttribute *)attribute {
    
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