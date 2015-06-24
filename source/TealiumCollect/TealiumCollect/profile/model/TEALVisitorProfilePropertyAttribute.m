//
//  TEALVisitorProfilePropertyAttribute.m
//  Tealium Collect Library
//
//  Created by George Webster on 6/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfilePropertyAttribute.h"
#import "TEALVisitorProfile+PrivateHeader.h"

@interface TEALVisitorProfilePropertyAttribute ()

@property (readwrite, copy, nonatomic) NSString *value;

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

- (BOOL) isEqualAttribute:(TEALVisitorProfileBaseAttribute *)attribute {
    
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