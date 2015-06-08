//
//  TEALVisitorProfileDateAttribute.m
//  Tealium Collect Library
//
//  Created by George Webster on 6/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfileDateAttribute.h"

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

- (BOOL) isEqualAttribute:(TEALVisitorProfileBaseAttribute *)attribute {
    
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
