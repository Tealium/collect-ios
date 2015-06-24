//
//  TEALVisitorProfileBadgeAttribute.m
//  Tealium Collect Library
//
//  Created by George Webster on 6/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfileBadgeAttribute.h"
#import "TEALVisitorProfile+PrivateHeader.h"

@interface TEALVisitorProfileBadgeAttribute ()

@property (readwrite, copy, nonatomic) NSString *name;

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