//
//  TEALProfileCurrentVisit.m
//  AS_Tests_UICatalog
//
//  Created by George Webster on 3/9/15.
//  Copyright (c) 2015 f. All rights reserved.
//

#import "TEALProfileCurrentVisit.h"

#import "TEALProfileAttribute.h"
#import "TEALProfile+PrivateHeader.h"
#import "TEALProfileHelpers.h"

@interface TEALProfileCurrentVisit ()

@property (readwrite) NSTimeInterval creationTimestamp;

@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) NSArray *flags;
@property (strong, nonatomic) NSArray *metrics;
@property (strong, nonatomic) NSArray *properties;

@property (readwrite) NSInteger totalEventCount;

@end

@implementation TEALProfileCurrentVisit

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self) {
        _totalEventCount    = [aDecoder decodeIntegerForKey:@"totalEventCount"];
        _creationTimestamp  = [aDecoder decodeDoubleForKey:@"creationTimestamp"];
        _dates              = [aDecoder decodeObjectForKey:@"dates"];
        _flags              = [aDecoder decodeObjectForKey:@"flags"];
        _metrics            = [aDecoder decodeObjectForKey:@"metrics"];
        _properties         = [aDecoder decodeObjectForKey:@"properties"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:self.totalEventCount forKey:@"totalEventCount"];
    [aCoder encodeDouble:self.creationTimestamp forKey:@"creationTimestamp"];
    [aCoder encodeObject:self.dates forKey:@"dates"];
    [aCoder encodeObject:self.flags forKey:@"flags"];
    [aCoder encodeObject:self.metrics forKey:@"metrics"];
    [aCoder encodeObject:self.properties forKey:@"properties"];
    
}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    TEALProfileCurrentVisit *copy   = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy.totalEventCount    = self.totalEventCount;
        copy.creationTimestamp  = self.creationTimestamp;
        copy.dates              = [self.dates copyWithZone:zone];
        copy.flags              = [self.flags copyWithZone:zone];
        copy.metrics            = [self.metrics copyWithZone:zone];
        copy.properties         = [self.properties copyWithZone:zone];
    }
    return copy;
}


#pragma mark - Info / Dump

- (NSString *) description {
    
    return [NSString stringWithFormat:@"\r%@: \r total event count: %lu \r creation timestamp: %f \r attributes: \r dates: %@ \r flags: %@ \r metrics: %@ \r properties: %@ \r",
            NSStringFromClass([self class]),
            (long)self.totalEventCount,
            self.creationTimestamp,
            self.dates,
            self.flags,
            self.metrics,
            self.properties];
}


@end
