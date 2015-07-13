//
//  TEALVisitorProfileStore.m
//  Tealium Collect Library
//
//  Created by George Webster on 2/18/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALVisitorProfileStore.h"

#import "TEALVisitorProfile.h"
#import "TEALVisitorProfile+PrivateHeader.h"
#import "TEALNetworkHelpers.h"
#import "TEALURLSessionManager.h"

#import "TEALError.h"
#import "TEALLogger.h"

@interface TEALVisitorProfileStore ()

@property (strong, nonatomic) TEALVisitorProfile *currentProfile;

@end

@implementation TEALVisitorProfileStore

- (instancetype) initWithConfiguration:(id<TEALVisitorProfileStoreConfiguration>)configuration {
    
    self = [self init];
    
    if (!self) {
        return nil;
    }
    
    if (!configuration) {
        return nil;
    }

    NSString *visitorID = [configuration visitorID];
    
    if (!visitorID) {
        return nil;
    }

    _configuration = configuration;
    
    _currentProfile = [[TEALVisitorProfile alloc] initWithVisitorID:visitorID];
    
    return self;
}

- (void) fetchProfileWithCompletion:(TEALVisitorProfileCompletionBlock)completion {

    if (![self.configuration urlSessionManager] || ![self.configuration profileURL]) {
        NSError *error = [TEALError errorWithCode:TEALErrorCodeMalformed
                                      description:@"Profile request unsuccessful"
                                           reason:@"properties urlSessionManager: TEALURLSessionManager and/or profileURL: NSURL are missing"
                                       suggestion:@"ensure the urlSessionManager and/or profileURL properties has been set with a valid object"];
        
        completion( nil, error );
        
        return;
    }
    
    NSURL *profileURL = [self.configuration profileURL];
    NSURLRequest *request = [TEALNetworkHelpers requestWithURL:profileURL];
    
    if (!request) {
        
        NSError *error = [TEALError errorWithCode:TEALErrorCodeMalformed
                                      description:@"Profile request unsuccessful"
                                           reason:[NSString stringWithFormat:@"Failed to generate valid request from URL: %@", profileURL]
                                       suggestion:@"Check the Account/Profile/Enviroment values in your configuration"];
        completion( nil, error ) ;
        return;
    }
    
    if (![[self.configuration urlSessionManager].reachability isReachable]) {
        
        TEAL_LogVerbose(@"offline: %@", request);
        NSError *error = [TEALError errorWithCode:TEALErrorCodeFailure
                                      description:@"Profile Request Failed"
                                           reason:@"Network Connection Unavailable"
                                       suggestion:@""];
        completion( nil, error );
        
        return;
    }
    
    __weak TEALVisitorProfileStore *weakSelf = self;
    
    TEALHTTPResponseJSONBlock urlCompletion = ^(NSHTTPURLResponse *response, NSDictionary *data, NSError *connectionError) {
        
        if (connectionError) {
            
            TEAL_LogVerbose(@"Profile Fetch Failed with response: %@, error: %@", response, [connectionError localizedDescription]);
        }
        
        TEALVisitorProfile *profile = weakSelf.currentProfile;
        
        [weakSelf updateProfile:profile
                     fromSource:data];
        
        completion( weakSelf.currentProfile, connectionError);
    };
    
    [[self.configuration urlSessionManager] performRequest:request
                                        withJSONCompletion:urlCompletion];
}


- (void) fetchProfileDefinitionsWithCompletion:(TEALDictionaryCompletionBlock)completion {

    if (![self.configuration urlSessionManager] || ![self.configuration profileDefinitionURL]) {
        NSError *error = [TEALError errorWithCode:TEALErrorCodeMalformed
                                      description:@"Profile request unsuccessful"
                                           reason:@"properties urlSessionManager: TEALURLSessionManager and/or profileDefinitionURL: NSURL are missing"
                                       suggestion:@"ensure the urlSessionManager and/or profileDefinitionURL properties has been set with a valid object"];
        
        completion( nil, error );
        
        return;
    }
    
    NSURL *profileDefinitionURL = [self.configuration profileDefinitionURL];

    NSURLRequest *request = [TEALNetworkHelpers requestWithURL:profileDefinitionURL];
    
    if (!request) {
        
        NSError *error = [TEALError errorWithCode:TEALErrorCodeMalformed
                                      description:@"Profile request unsuccessful"
                                           reason:[NSString stringWithFormat:@"Failed to generate valid request from URL: %@", profileDefinitionURL]
                                       suggestion:@"Check the Account/Profile/Enviroment values in your configuration"];

        completion( nil, error) ;
        return;
    }

    TEALHTTPResponseJSONBlock urlCompletion = ^(NSHTTPURLResponse *response, NSDictionary *data, NSError *connectionError) {
        
        if (connectionError) {
            
            TEAL_LogVerbose(@"Profile Definitions Fetch Failed with response: %@, error: %@", response, [connectionError localizedDescription]);
        }
        completion( data, connectionError);
    };
    
    [[self.configuration urlSessionManager] performRequest:request
                                        withJSONCompletion:urlCompletion];
}


- (void) updateProfile:(TEALVisitorProfile *)profile
            fromSource:(NSDictionary *)source {
    
    profile.rawProfile = source;
    
    [self updateProfileAttributes:profile
                       fromSource:source];

    [self updateProfileCurrentVisit:profile
                         fromSource:source];
}

#pragma mark - Attributes

- (void) updateProfileAttributes:(TEALVisitorProfile *)profile
                      fromSource:(NSDictionary *)source {
    
    [self updateProfileAudiences:profile
                      fromSource:source];
    
    [self updateProfileBadges:profile
                   fromSource:source];

    [self updateProfileDates:profile
                  fromSource:source];
    
    [self updateProfileFlags:profile
                  fromSource:source];
    
    [self updateProfileMetrics:profile
                    fromSource:source];

    [self updateProfileProperties:profile
                       fromSource:source];
}

- (void) updateProfileAudiences:(TEALVisitorProfile *)profile
                     fromSource:(NSDictionary *)source {
    
    NSArray *audiences = [TEALVisitorProfileHelpers arrayOfAudiencesFromSource:source];
    
    // TODO notify delegates

    profile.audiences = audiences;
}

- (void) updateProfileBadges:(TEALVisitorProfile *)profile
                  fromSource:(NSDictionary *)source {
    
    NSArray *badges = [TEALVisitorProfileHelpers arrayOfBadgesFromSource:source];
    
    // TODO notify delegates

    profile.badges = badges;
}

- (void) updateProfileDates:(TEALVisitorProfile *)profile
                 fromSource:(NSDictionary *)source {
    
    NSArray *dates = [TEALVisitorProfileHelpers arrayOfDatesFromSource:source];
    
    // TODO notify delegates

    profile.dates = dates;
}

- (void) updateProfileFlags:(TEALVisitorProfile *)profile
                 fromSource:(NSDictionary *)source {
    
    NSArray *flags = [TEALVisitorProfileHelpers arrayOfFlagsFromSource:source];
    
    // TODO notify delegates

    profile.flags = flags;
}

- (void) updateProfileMetrics:(TEALVisitorProfile *)profile
                   fromSource:(NSDictionary *)source {
    
    NSArray *metrics = [TEALVisitorProfileHelpers arrayOfMetricsFromSource:source];
    
    // TODO notify delegates

    profile.metrics = metrics;
}

- (void) updateProfileProperties:(TEALVisitorProfile *)profile
                      fromSource:(NSDictionary *)source {
    
    NSArray *properties = [TEALVisitorProfileHelpers arrayOfPropertiesFromSource:source];

    // TODO notify delegates

    profile.properties = properties;
}


#pragma mark - Current Visit

- (void) updateProfileCurrentVisit:(TEALVisitorProfile *)profile fromSource:(NSDictionary *)source {
    
    NSDictionary *sourceVisit = source[@"current_visit"];
    
    if (!sourceVisit) {
        return;
    }
    
    TEALVisitorProfileCurrentVisit *visit = [TEALVisitorProfileCurrentVisit new];
    
    
    visit.totalEventCount = [source[@"total_event_count"] unsignedIntegerValue];
    visit.creationTimestamp = [source[@"creation_ts"] doubleValue];
    
    [self updateCurrentVisitAttributes:visit
                            fromSource:source];
    
    // TODO notify delegates
    
    profile.currentVisit = visit;
}

#pragma mark - Current Visit Attributes

- (void) updateCurrentVisitAttributes:(TEALVisitorProfileCurrentVisit *)visit
                           fromSource:(NSDictionary *)source {

    [self updateCurrentVisitDates:visit
                       fromSource:source];
    
    [self updateCurrentVisitFlags:visit
                       fromSource:source];
    
    [self updateCurrentVisitMetrics:visit
                         fromSource:source];

    [self updateCurrentVisitProperties:visit
                            fromSource:source];
}

- (void) updateCurrentVisitDates:(TEALVisitorProfileCurrentVisit *)visit
                      fromSource:(NSDictionary *)source {
    
    NSArray *dates = [TEALVisitorProfileHelpers arrayOfDatesFromSource:source];
    
    // TODO notify delegates

    visit.dates = dates;
}

- (void) updateCurrentVisitFlags:(TEALVisitorProfileCurrentVisit *)visit
                      fromSource:(NSDictionary *)source {
    
    NSArray *flags = [TEALVisitorProfileHelpers arrayOfFlagsFromSource:source];

    // TODO notify delegates

    visit.flags = flags;
}

- (void) updateCurrentVisitMetrics:(TEALVisitorProfileCurrentVisit *)visit
                        fromSource:(NSDictionary *)source {
    
    NSArray *metrics = [TEALVisitorProfileHelpers arrayOfMetricsFromSource:source];

    // TODO notify delegates

    visit.metrics = metrics;
}

- (void) updateCurrentVisitProperties:(TEALVisitorProfileCurrentVisit *)visit
                           fromSource:(NSDictionary *)source {
    
    NSArray *properties = [TEALVisitorProfileHelpers arrayOfPropertiesFromSource:source];

    // TODO notify delegates

    visit.properties = properties;
}


@end
