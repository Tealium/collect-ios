//
//  TEALProfile.m
//  TEALAudienceStream
//
//  Created by George Webster on 1/5/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfile.h"
#import "TEALProfileAttribute.h"
#import "TEALProfile+PrivateHeader.h"
#import "TEALProfileHelpers.h"

@interface TEALVisitorProfile()

@property (copy, readwrite) NSString *visitorID;

@property (strong, nonatomic) NSDictionary *rawProfile;

@property (strong, nonatomic) NSArray *audiences;
@property (strong, nonatomic) NSArray *badges;
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) NSArray *flags;
@property (strong, nonatomic) NSArray *metrics;
@property (strong, nonatomic) NSArray *properties;

@property (strong, nonatomic) TEALProfileCurrentVisit *currentVisit;

@end

@implementation TEALVisitorProfile

- (instancetype) initWithVisitorID:(NSString *)visitorID {
    
    self = [self init];
    
    if (self) {
        _visitorID = [visitorID copy];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {

    NSString *visitorID  = [aDecoder decodeObjectForKey:@"visitorID"];

    self = [self initWithVisitorID:visitorID];
    
    if (self) {
        _audiences  = [aDecoder decodeObjectForKey:@"audiences"];
        _badges     = [aDecoder decodeObjectForKey:@"badges"];
        _dates      = [aDecoder decodeObjectForKey:@"dates"];
        _flags      = [aDecoder decodeObjectForKey:@"flags"];
        _metrics    = [aDecoder decodeObjectForKey:@"metrics"];
        _properties = [aDecoder decodeObjectForKey:@"properties"];
        
        _currentVisit = [aDecoder decodeObjectForKey:@"currentVisit"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.visitorID forKey:@"visitorID"];
    [aCoder encodeObject:self.audiences forKey:@"audiences"];
    [aCoder encodeObject:self.badges forKey:@"badges"];
    [aCoder encodeObject:self.dates forKey:@"dates"];
    [aCoder encodeObject:self.flags forKey:@"flags"];
    [aCoder encodeObject:self.metrics forKey:@"metrics"];
    [aCoder encodeObject:self.properties forKey:@"properties"];

    [aCoder encodeObject:self.currentVisit forKey:@"currentVisit"];

}

- (instancetype) copyWithZone:(NSZone *)zone {
    
    NSString *visitorID = [self.visitorID copyWithZone:zone];
    TEALVisitorProfile *copy   = [[[self class] allocWithZone:zone] initWithVisitorID:visitorID];
    
    if (copy) {
        copy.audiences  = [self.audiences copyWithZone:zone];
        copy.badges     = [self.badges copyWithZone:zone];
        copy.dates      = [self.dates copyWithZone:zone];
        copy.flags      = [self.flags copyWithZone:zone];
        copy.metrics    = [self.metrics copyWithZone:zone];
        copy.properties = [self.properties copyWithZone:zone];
        
        copy.currentVisit   = [self.currentVisit copyWithZone:zone];
    }
    return copy;
}


- (BOOL) isValid {
    return (self.visitorID != nil);
}

- (void) storeRawProfile:(NSDictionary *)rawProfile {
    
    self.rawProfile = rawProfile;
}



#pragma mark - Info / Dump

- (NSString *) description {

    return [NSString stringWithFormat:@"\r%@: \r visitorID: %@ \r current visit: %@ \r attributes: \r audiences: %@ \r badges: %@ \r dates: %@ \r flags: %@ \r metrics: %@ \r properties: %@ \r",
            NSStringFromClass([self class]),
            self.visitorID,
            self.currentVisit,
            self.audiences,
            self.badges,
            self.dates,
            self.flags,
            self.metrics,
            self.properties];
}

@end
