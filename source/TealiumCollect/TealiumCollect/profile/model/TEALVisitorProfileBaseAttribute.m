//
//  TEALVisitorProfileAttribute.m
//  Tealium Collect Library
//
//  Created by George Webster on 2/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfileBaseAttribute.h"

@interface TEALVisitorProfileBaseAttribute()

@property (copy, nonatomic) NSString *attributeID;

@property TEALVisitorProfileAttributeType type;

@end

@implementation TEALVisitorProfileBaseAttribute

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

- (BOOL) isEqualAttribute:(TEALVisitorProfileBaseAttribute *)attribute {
    
    if (![attribute isKindOfClass:[TEALVisitorProfileBaseAttribute class]]) {
        return NO;
    }
    
    if (!self.attributeID || !attribute.attributeID) {
        return NO;
    }
    
    return [self.attributeID isEqualToString:attribute.attributeID];
}


@end
