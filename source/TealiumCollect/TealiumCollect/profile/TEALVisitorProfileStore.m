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

@property (strong, nonatomic) NSURL *profileURL;
@property (strong, nonatomic) NSURL *profileDefinitionURL;

@property (weak, nonatomic) TEALURLSessionManager *urlSessionManager;

@end

@implementation TEALVisitorProfileStore

- (instancetype) initWithURLSessionManager:(TEALURLSessionManager *)urlSessionManager
                                profileURL:(NSURL *)profileURL
                             definitionURL:(NSURL *)definitionURL
                                 visitorID:(NSString *)visitorID {

    self = [self init];
    
    if (self) {
        _profileURL             = profileURL;
        _profileDefinitionURL   = definitionURL;
        _urlSessionManager      = urlSessionManager;
        _currentProfile         = [[TEALVisitorProfile alloc] initWithVisitorID:visitorID];
    }
    
    return self;
}

- (void) fetchProfileWithCompletion:(TEALVisitorProfileCompletionBlock)completion {

    if (!self.urlSessionManager || !self.profileURL) {
        NSError *error = [TEALError errorWithCode:TEALErrorCodeMalformed
                                      description:@"Profile request unsuccessful"
                                           reason:@"properties urlSessionManager: TEALURLSessionManager and/or profileURL: NSURL are missing"
                                       suggestion:@"ensure the urlSessionManager and/or profileURL properties has been set with a valid object"];
        
        completion( nil, error );
        
        return;
    }
    
    
    NSURLRequest *request = [TEALNetworkHelpers requestWithURL:self.profileURL];
    
    if (!request) {
        
        NSError *error = [TEALError errorWithCode:TEALErrorCodeMalformed
                                      description:@"Profile request unsuccessful"
                                           reason:[NSString stringWithFormat:@"Failed to generate valid request from URL: %@", self.profileURL]
                                       suggestion:@"Check the Account/Profile/Enviroment values in your configuration"];
        completion( nil, error ) ;
        return;
    }
    
    if (![self.urlSessionManager.reachability isReachable]) {
        
        TEAL_LogVerbose(@"offline: %@", request);
        NSError *error = [TEALError errorWithCode:TEALErrorCodeFailure
                                      description:@"Profile Request Failed"
                                           reason:@"Network Connection Unavailable"
                                       suggestion:@""];
        completion( nil, error );
        
        return;
    }
    
    __weak TEALVisitorProfileStore *weakSelf = self;
    
    [self.urlSessionManager performRequest:request
                     withJSONCompletion:^(NSHTTPURLResponse *response, NSDictionary *data, NSError *connectionError) {

                         if (connectionError) {
                             
                             TEAL_LogVerbose(@"Profile Fetch Failed with response: %@, error: %@", response, [connectionError localizedDescription]);
                         }
                         
                         TEALVisitorProfile *profile = weakSelf.currentProfile;
                         
                         [weakSelf updateProfile:profile
                                      fromSource:data];

                         completion( weakSelf.currentProfile, connectionError);
                     }];
}


- (void) fetchProfileDefinitionsWithCompletion:(TEALDictionaryCompletionBlock)completion {

    if (!self.urlSessionManager || !self.profileDefinitionURL) {
        NSError *error = [TEALError errorWithCode:TEALErrorCodeMalformed
                                      description:@"Profile request unsuccessful"
                                           reason:@"properties urlSessionManager: TEALURLSessionManager and/or profileDefinitionURL: NSURL are missing"
                                       suggestion:@"ensure the urlSessionManager and/or profileDefinitionURL properties has been set with a valid object"];
        
        completion( nil, error );
        
        return;
    }
    
    NSURLRequest *request = [TEALNetworkHelpers requestWithURL:self.profileDefinitionURL];
    
    if (!request) {
        
        NSError *error = [TEALError errorWithCode:TEALErrorCodeMalformed
                                      description:@"Profile request unsuccessful"
                                           reason:[NSString stringWithFormat:@"Failed to generate valid request from URL: %@", self.profileDefinitionURL]
                                       suggestion:@"Check the Account/Profile/Enviroment values in your configuration"];

        completion( nil, error) ;
        return;
    }

    [self.urlSessionManager performRequest:request
                     withJSONCompletion:^(NSHTTPURLResponse *response, NSDictionary *data, NSError *connectionError) {

                         if (connectionError) {
                             
                             TEAL_LogVerbose(@"Profile Definitions Fetch Failed with response: %@, error: %@", response, [connectionError localizedDescription]);
                         }
                         completion( data, connectionError);
                     }];
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
