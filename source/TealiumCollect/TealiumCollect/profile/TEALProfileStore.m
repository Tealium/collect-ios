//
//  TEALProfileStore.m
//  AudienceStream Library
//
//  Created by George Webster on 2/18/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALProfileStore.h"

#import "TEALVisitorProfile.h"
#import "TEALProfile+PrivateHeader.h"
#import "TEALNetworkHelpers.h"
#import "TEALURLSessionManager.h"

#import "TEALError.h"
#import "TEALLogger.h"

@interface TEALProfileStore ()

@property (strong, nonatomic) TEALVisitorProfile *currentProfile;

@property (strong, nonatomic) NSURL *profileURL;
@property (strong, nonatomic) NSURL *profileDefinitionURL;

@property (weak, nonatomic) TEALURLSessionManager *urlSessionManager;

@end

@implementation TEALProfileStore

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

- (void) fetchProfileWithCompletion:(TEALProfileCompletionBlock)completion {

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
    
    __weak TEALProfileStore *weakSelf = self;
    
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
    
    NSArray *audiences = [TEALProfileHelpers arrayOfAudiencesFromSource:source];
    
    // TODO notify delegates

    profile.audiences = audiences;
}

- (void) updateProfileBadges:(TEALVisitorProfile *)profile
                  fromSource:(NSDictionary *)source {
    
    NSArray *badges = [TEALProfileHelpers arrayOfBadgesFromSource:source];
    
    // TODO notify delegates

    profile.badges = badges;
}

- (void) updateProfileDates:(TEALVisitorProfile *)profile
                 fromSource:(NSDictionary *)source {
    
    NSArray *dates = [TEALProfileHelpers arrayOfDatesFromSource:source];
    
    // TODO notify delegates

    profile.dates = dates;
}

- (void) updateProfileFlags:(TEALVisitorProfile *)profile
                 fromSource:(NSDictionary *)source {
    
    NSArray *flags = [TEALProfileHelpers arrayOfFlagsFromSource:source];
    
    // TODO notify delegates

    profile.flags = flags;
}

- (void) updateProfileMetrics:(TEALVisitorProfile *)profile
                   fromSource:(NSDictionary *)source {
    
    NSArray *metrics = [TEALProfileHelpers arrayOfMetricsFromSource:source];
    
    // TODO notify delegates

    profile.metrics = metrics;
}

- (void) updateProfileProperties:(TEALVisitorProfile *)profile
                      fromSource:(NSDictionary *)source {
    
    NSArray *properties = [TEALProfileHelpers arrayOfPropertiesFromSource:source];

    // TODO notify delegates

    profile.properties = properties;
}


#pragma mark - Current Visit

- (void) updateProfileCurrentVisit:(TEALVisitorProfile *)profile fromSource:(NSDictionary *)source {
    
    NSDictionary *sourceVisit = source[@"current_visit"];
    
    if (!sourceVisit) {
        return;
    }
    
    TEALProfileCurrentVisit *visit = [TEALProfileCurrentVisit new];
    
    
    visit.totalEventCount = [source[@"total_event_count"] integerValue];
    visit.creationTimestamp = [source[@"creation_ts"] doubleValue];
    
    [self updateCurrentVisitAttributes:visit
                            fromSource:source];
    
    // TODO notify delegates
    
    profile.currentVisit = visit;
}

#pragma mark - Current Visit Attributes

- (void) updateCurrentVisitAttributes:(TEALProfileCurrentVisit *)visit
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

- (void) updateCurrentVisitDates:(TEALProfileCurrentVisit *)visit
                      fromSource:(NSDictionary *)source {
    
    NSArray *dates = [TEALProfileHelpers arrayOfDatesFromSource:source];
    
    // TODO notify delegates

    visit.dates = dates;
}

- (void) updateCurrentVisitFlags:(TEALProfileCurrentVisit *)visit
                      fromSource:(NSDictionary *)source {
    
    NSArray *flags = [TEALProfileHelpers arrayOfFlagsFromSource:source];

    // TODO notify delegates

    visit.flags = flags;
}

- (void) updateCurrentVisitMetrics:(TEALProfileCurrentVisit *)visit
                        fromSource:(NSDictionary *)source {
    
    NSArray *metrics = [TEALProfileHelpers arrayOfMetricsFromSource:source];

    // TODO notify delegates

    visit.metrics = metrics;
}

- (void) updateCurrentVisitProperties:(TEALProfileCurrentVisit *)visit
                           fromSource:(NSDictionary *)source {
    
    NSArray *properties = [TEALProfileHelpers arrayOfPropertiesFromSource:source];

    // TODO notify delegates

    visit.properties = properties;
}


@end
