//
//  TEALVisitorProfileAudienceAttribute.m
//  Tealium Collect Library
//
//  Created by George Webster on 6/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfileAudienceAttribute.h"
#import "TEALVisitorProfile+PrivateHeader.h"

@interface TEALVisitorProfileAudienceAttribute ()

@property (readwrite, copy, nonatomic) NSString *name;

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